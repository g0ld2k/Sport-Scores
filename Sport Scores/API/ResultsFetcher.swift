//
//  ScoreFetcher.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/13/21.
//

import Foundation
import Combine

/// Protocol for fetching results
protocol ResultsFetchable {
    func latestResults() -> AnyPublisher<[Result], ResultsError>
}

/// Data access for fetching results
class ResultsFetcher: ResultsFetchable {
    private let session: URLSession
    
    /// Default init
    /// - Parameter session: URL session for overriding (used primarily for testing)
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Fetches the latest results
    /// - Returns: publisher of results and results error
    func latestResults() -> AnyPublisher<[Result], ResultsError> {
        return fetch()
    }
    
    /// Fetches results from the web
    /// - Returns: publisher of results and results error
    private func fetch() -> AnyPublisher<[Result], ResultsError> {
        let urlStr = "https://ancient-wood-1161.getsandbox.com:443/results"
        guard let url = URL(string: urlStr) else {
            let error = ResultsError.network(description: "Couldn't create URL")
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
                self.process(results: $0)
            }
            .eraseToAnyPublisher()
    }
    
    /// Decodes JSON into intermediate set of models
    /// - Returns: Publisher containing generic type and ResultsError
    func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, ResultsError> {
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
    
    /// Creates array of Results from SportsScoreResponse
    /// - Parameter response: unwrapped set of results
    /// - Returns: a consolodated array of results
    private func process(results response: SportsScoresResponse) -> [Result] {
        var results: [Result] = []
        var latestDay: Date = response.f1Results[0].publicationDate
        
        for f1Result in response.f1Results {
            if shouldClearScores(resultDate: f1Result.publicationDate, latestDay: latestDay) {
                latestDay = f1Result.publicationDate
                results = []
            } else if Calendar.current.isDate(latestDay, inSameDayAs: f1Result.publicationDate) {
                results.append(F1Result(publicationDate: f1Result.publicationDate, winner: f1Result.winner, tournament: f1Result.tournament, seconds: f1Result.seconds))
            }
        }
        
        for nbaResult in response.nbaResults {
            if shouldClearScores(resultDate: nbaResult.publicationDate, latestDay: latestDay) {
                latestDay = nbaResult.publicationDate
                results = []
            } else if Calendar.current.isDate(latestDay, inSameDayAs: nbaResult.publicationDate) {
                results.append(NbaResult(publicationDate: nbaResult.publicationDate, winner: nbaResult.winner, tournament: nbaResult.tournament, looser: nbaResult.looser, gameNumber: nbaResult.gameNumber, mvp: nbaResult.mvp))
            }
        }
        
        for tennisResult in response.tennisResults {
            if shouldClearScores(resultDate: tennisResult.publicationDate, latestDay: latestDay) {
                latestDay = tennisResult.publicationDate
                results = []
            } else if Calendar.current.isDate(latestDay, inSameDayAs: tennisResult.publicationDate) {
                results.append(TennisResult(publicationDate: tennisResult.publicationDate, winner: tennisResult.winner, tournament: tennisResult.tournament, looser: tennisResult.looser, numberOfSets: tennisResult.numberOfSets))
            }
        }
        
        return results.sorted { rScore, lScore in
            rScore.publicationDate > lScore.publicationDate
        }
    }
    
    /// Checks to see if a newer score exists, which is a signal to clear the latest scores
    /// - Parameters:
    ///   - resultsDate: date of result to compare
    ///   - latestDay: newest score date so far
    /// - Returns: if the scores should be cleared
    private func shouldClearScores(resultDate: Date, latestDay: Date) -> Bool {
        return latestDay < resultDate && !Calendar.current.isDate(latestDay, inSameDayAs: resultDate)
    }
}

