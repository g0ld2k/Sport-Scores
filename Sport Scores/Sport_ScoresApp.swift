//
//  Sport_ScoresApp.swift
//  Sport Scores
//
//  Created by Chris on 11/10/21.
//

import SwiftUI

@main
struct Sport_ScoresApp: App {
    private let scoreFetcher: ScoreFetcher
    private let viewModel: ScoresViewModel
    
    init() {
        scoreFetcher = ScoreFetcher()
        viewModel = ScoresViewModel(scoreFetcher: scoreFetcher)
    }
    
    var body: some Scene {
        WindowGroup {
            ScoresView(viewModel: viewModel)
        }
    }
}
