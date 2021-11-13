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
    @Published var scoreDate: Date = Date()
    
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
            .map { self.process(scores: $0) }
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \ScoresViewModel.rawScores, on: self)
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
