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
    private var disposables = Set<AnyCancellable>()
    
    @Published var scoreDate: String = ""
    @Published var dataSource: [ScoreRowViewModel] = []
    
    func fetchScores() {
        let scoreFetcher = ScoreFetcher()
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
