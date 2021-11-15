//
//  Sport_ScoresApp.swift
//  Sport Scores
//
//  Created by Chris on 11/10/21.
//

import SwiftUI

@main
struct Sport_ScoresApp: App {
    private let resultsFetcher: ResultsFetcher
    private let viewModel: ResultsViewModel
    
    init() {
        resultsFetcher = ResultsFetcher()
        viewModel = ResultsViewModel(resultsFetcher: resultsFetcher)
    }
    
    var body: some Scene {
        WindowGroup {
            ResultsView(viewModel: viewModel)
        }
    }
}
