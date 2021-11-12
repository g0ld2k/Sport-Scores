//
//  ScoreFetcher.swift
//  Sport Scores
//
//  Created by Chris on 11/11/21.
//

import Foundation
import Combine

protocol ScoreFetchable {
    func latestScores() -> AnyPublisher<SportsScoresResponse, ScoreError>
}

class ScoreFetcher {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
}

extension ScoreFetcher: ScoreFetchable {
    func latestScores() -> AnyPublisher<SportsScoresResponse, ScoreError> {
        return fetch()
    }
    
    func fetch<T>() -> AnyPublisher<T, ScoreError> where T: Decodable {
        guard let url = URL(string: "https://ancient-wood-1161.getsandbox.com:443/results") else {
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
}
