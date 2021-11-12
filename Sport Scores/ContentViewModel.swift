//
//  ContentViewModel.swift
//  Sport Scores
//
//  Created by Chris on 11/11/21.
//

import SwiftUI
import Combine

class ContentViewModel: ObservableObject, Identifiable {
    @Published var dataSource: ContentViewModel?
    
    private let scoreFetcher: ScoreFetchable
    private var disposables = Set<AnyCancellable>()
    
    init(scoreFetcher: ScoreFetchable) {
        self.scoreFetcher = scoreFetcher
    }
    
    func refresh() {
        scoreFetcher
            .latestScores()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] value in
                guard let self = self else {return}
                switch value {
                case .failure:
                    self.dataSource = nil
                    print("Failure encountered \(value)")
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] scores in
                guard let self = self else { return }
//                self.dataSource = scores
                print(".sink() received \(scores)")
            })
            .store(in: &disposables)
    }
}
