//
//  ScoresView.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import SwiftUI

/// Scores View
struct ScoresView: View {
    @ObservedObject var viewModel: ScoresViewModel
    @State private var showResults = false
    
    /// Default init
    /// - Parameter viewModel: view model to drive score view model
    init(viewModel: ScoresViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if (!showResults) {
            Button("Get Results") {
                showResults.toggle()
            }.accessibilityLabel("Get Results Button")
        } else {
            VStack(alignment: .center) {
                if (viewModel.dataSource.isEmpty) {
                    Text("Loading...")
                    ProgressView().onAppear {
                        self.viewModel.fetchScores()
                    }
                }
                else {
                    Text(viewModel.scoreDate)
                    List {
                        Section {
                            ForEach(viewModel.dataSource, content: ScoreRowView.init(viewModel:))
                        }
                    }.listStyle(.grouped)
                }
            }
        }
    }
}
