//
//  ScoresViewModel.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import Combine
import SwiftUI

class ScoresViewModel: ObservableObject {
    private let urlStr = "https://ancient-wood-1161.getsandbox.com:443/results"
    private var task: AnyCancellable?
    
    @Published var rawScores: [Score] = []
    
    func fetchScores() {
        guard let url = URL(string: urlStr) else { return }
        
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm:ss a"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        task = URLSession.shared.dataTaskPublisher(for: request)
                .map { $0.data }
                .decode(type: SportsScoresResponse.self, decoder: decoder)
                .map {
                    var scores: [Score] = []
                    for f1Result in $0.f1Results {
                        scores.append(F1Score(publicationDate: f1Result.publicationDate, winner: f1Result.winner, tournament: f1Result.tournament, seconds: f1Result.seconds))
                    }
                    for nbaResult in $0.nbaResults {
                        scores.append(NbaScore(publicationDate: nbaResult.publicationDate, winner: nbaResult.winner, tournament: nbaResult.tournament, looser: nbaResult.looser, gameNumber: nbaResult.gameNumber, mvp: nbaResult.mvp))
                    }
                    for tennisResult in $0.tennis {
                        scores.append(TennisScore(publicationDate: tennisResult.publicationDate, winner: tennisResult.winner, tournament: tennisResult.tournament, looser: tennisResult.looser, numberOfSets: tennisResult.numberOfSets))
                    }
                    return scores
                }
                .replaceError(with: [])
                .eraseToAnyPublisher()
                .receive(on: RunLoop.main)
                .assign(to: \ScoresViewModel.rawScores, on: self)
    }
}
