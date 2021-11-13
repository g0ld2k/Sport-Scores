//
//  ScoreFetcher.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/13/21.
//

import Foundation
import Combine

protocol ScoreFetchable {
    func latestScores() -> AnyPublisher<[Score], ScoreError>
}

class ScoreFetcher: ScoreFetchable {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func latestScores() -> AnyPublisher<[Score], ScoreError> {
        return fetch()
    }
    
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
        
        for tennisResult in response.tennis {
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
    
    private func shouldClearScores(scoreDate: Date, latestDay: Date) -> Bool {
        return latestDay < scoreDate && !Calendar.current.isDate(latestDay, inSameDayAs: scoreDate)
    }
}

