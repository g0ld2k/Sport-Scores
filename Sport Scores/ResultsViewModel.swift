//
//  ResultsViewModel.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import Combine
import SwiftUI

/// Results View Model
class ResultsViewModel: ObservableObject {
    private var disposables = Set<AnyCancellable>()
    private let resultsFetcher: ResultsFetchable
    
    @Published var resultsDate: String = ""
    @Published var dataSource: [ResultRowViewModel] = []
    
    /// Default init
    /// - Parameter resultsFetcher:
    init(resultsFetcher: ResultsFetchable) {
        self.resultsFetcher = resultsFetcher
    }
    
    /// Fetches latest results
    func fetchResults() {
        resultsFetcher.latestResults()
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
            }, receiveValue: { [weak self] results in
                guard let self = self else { return }
                
                self.dataSource = results.map(ResultRowViewModel.init)
                
                if let firstResult = results.first {
                    self.resultsDate = firstResult.publicationDate.formatted()
                }
            })
            .store(in: &disposables)
    }
}
