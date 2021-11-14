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
