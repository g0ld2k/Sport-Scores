//
//  ScoresViewModel.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import Combine
import SwiftUI

/// Scores View Model
class ResultsViewModel: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    private let scoreFetcher: ScoreFetchable

    @Published var scoreDate: String = ""
    @Published var dataSource: [ScoreRowViewModel] = []

    /// Default init
    /// - Parameter scoreFetcher:
    init(scoreFetcher: ScoreFetchable) {
        self.scoreFetcher = scoreFetcher
    }

    /// Fetches latest scores
    func fetchScores() {
        scoreFetcher.latestScores()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
              guard let self = self else { return }
              switch value {
              case .failure:
                self.dataSource = []
                  print("Something failed... \(value)")
              case .finished:
                break
              }
            }, receiveValue: { [weak self] scores in
                guard let self = self else { return }

                self.dataSource = scores.map(ScoreRowViewModel.init)

                if let firstScore = scores.first {
                    self.scoreDate = firstScore.publicationDate.formatted()
                }
            })
            .store(in: &disposables)
    }
}
