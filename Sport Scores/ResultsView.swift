//
//  ResultsView.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import SwiftUI

/// Results View
struct ResultsView: View {
    @ObservedObject var viewModel: ResultsViewModel
    @State private var showResults = false
    
    /// Default init
    /// - Parameter viewModel: view model to drive results view model
    init(viewModel: ResultsViewModel) {
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
                        self.viewModel.fetchResults()
                    }
                }
                else {
                    Text(viewModel.resultsDate)
                    List {
                        Section {
                            ForEach(viewModel.dataSource, content: ResultRowView.init(viewModel:))
                        }
                    }.listStyle(.grouped)
                }
            }
        }
    }
}
