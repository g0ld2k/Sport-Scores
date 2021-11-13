//
//  ScoresView.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import SwiftUI

struct ScoresView: View {
    @ObservedObject var viewModel = ScoresViewModel()
    @State private var showResults = false
    
    var body: some View {
        if (!showResults) {
            Button("Get Results") {
                showResults.toggle()
            }
        } else {
            VStack(alignment: .center) {
                if (viewModel.rawScores.isEmpty) {
                    Text("Loading...")
                }
                else {
                    Text(viewModel.rawScores[0].publicationDate.formatted())
                }
                List(viewModel.rawScores, id: \.self) {
                    ScoreRowView(score: $0)
                }.navigationBarTitle("Scores")
                    .onAppear {
                        self.viewModel.fetchScores()
                    }
            }
        }
    }
}
