//
//  ScoreFetcher.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/13/21.
//

import Foundation
import Combine

/// Protocol for fetching scores
protocol ScoreFetchable {
    func latestScores() -> AnyPublisher<[Score], ScoreError>
}

/// Data access for fetching scores
class ScoreFetcher: ScoreFetchable {
    private let session: URLSession
    
    /// Default init
    /// - Parameter session: URL session for overriding (used primarily for testing)
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetches the latest scores
    /// - Returns: publisher of scores and score error
    func latestScores() -> AnyPublisher<[Score], ScoreError> {
        return fetch()
    }
    
    /// Fetches scores from the web
    /// - Returns: publisher of scores and score error
    private func fetch() -> AnyPublisher<[Score], ScoreError> {
        let urlStr = "https://ancient-wood-1161.getsandbox.com:443/results"
        guard let url = URL(string: urlStr) else {
            let error = ScoreError.network(description: "Couldn't create URL")
            return Fail(error: error).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return session.dataTaskPublisher(for: request)
            .mapError { error in
            .network(description: error.localizedDescription)
            }
            .flatMap(maxPublishers: .max(1)) { pair in
                self.decode(pair.data)
            }
            .map {
                self.process(scores: $0)
            }
            .eraseToAnyPublisher()
    }
    
    /// Decodes JSON into intermediate set of models
    /// - Returns: Publisher containing generic type and ScoreError
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, ScoreError> {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm:ss a"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
            .parsing(description: error.localizedDescription)
            }
            .eraseToAnyPublisher()
    }
    
    /// Creates array of Scores from SportsScoreResponse
    /// - Parameter response: unwrapped set of scores
    /// - Returns: a consolodated array of scores
    private func process(scores response: SportsScoresResponse) -> [Score] {
        var scores: [Score] = []
        var latestDay: Date = response.f1Results[0].publicationDate
        
        for f1Result in response.f1Results {
            if shouldClearScores(scoreDate: f1Result.publicationDate, latestDay: latestDay) {
                latestDay = f1Result.publicationDate
                scores = []
            } else if Calendar.current.isDate(latestDay, inSameDayAs: f1Result.publicationDate) {
                scores.append(F1Score(publicationDate: f1Result.publicationDate, winner: f1Result.winner, tournament: f1Result.tournament, seconds: f1Result.seconds))
            }
        }
        
        for nbaResult in response.nbaResults {
            if shouldClearScores(scoreDate: nbaResult.publicationDate, latestDay: latestDay) {
                latestDay = nbaResult.publicationDate
                scores = []
            } else if Calendar.current.isDate(latestDay, inSameDayAs: nbaResult.publicationDate) {
                scores.append(NbaScore(publicationDate: nbaResult.publicationDate, winner: nbaResult.winner, tournament: nbaResult.tournament, looser: nbaResult.looser, gameNumber: nbaResult.gameNumber, mvp: nbaResult.mvp))
            }
        }
        
        for tennisResult in response.tennisResults {
            if shouldClearScores(scoreDate: tennisResult.publicationDate, latestDay: latestDay) {
                latestDay = tennisResult.publicationDate
                scores = []
            } else if Calendar.current.isDate(latestDay, inSameDayAs: tennisResult.publicationDate) {
                scores.append(TennisScore(publicationDate: tennisResult.publicationDate, winner: tennisResult.winner, tournament: tennisResult.tournament, looser: tennisResult.looser, numberOfSets: tennisResult.numberOfSets))
            }
        }
        
        return scores.sorted { rScore, lScore in
            rScore.publicationDate > lScore.publicationDate
        }
    }
    
    /// Checks to see if a newer score exists, which is a signal to clear the latest scores
    /// - Parameters:
    ///   - scoreDate: date of score to compare
    ///   - latestDay: newest score date so far
    /// - Returns: if the scores should be cleared
    private func shouldClearScores(scoreDate: Date, latestDay: Date) -> Bool {
        return latestDay < scoreDate && !Calendar.current.isDate(latestDay, inSameDayAs: scoreDate)
    }
}

