//
//  ScoresView.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import SwiftUI

struct ScoresView: View {
    @ObservedObject var viewModel = ScoresViewModel()
    var body: some View {
        
            List(viewModel.rawScores, id: \.self) {
                ScoreRowView(score: $0)
            }.navigationBarTitle("Scores")
                .onAppear {
                    self.viewModel.fetchScores()
            }
    }
}
