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
        if !showResults {
            Button("Get Results") {
                showResults.toggle()
            }
            .accessibilityLabel("Get Results Button")
            .buttonStyle(.bordered)
            .tint(.green)
        } else {
            VStack(alignment: .center) {
                if viewModel.dataSource.isEmpty && viewModel.error.isEmpty {
                    Text("Loading...")
                    ProgressView().onAppear {
                        self.viewModel.fetchResults()
                    }
                } else if !viewModel.error.isEmpty {
                    Text("An error occured..\n\(viewModel.error)")
                        .foregroundColor(Color.red)
                        .font(.body)
                    Button("Retry") {
                        viewModel.dataSource = []
                        viewModel.error = ""
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                } else {
                    Text("Results for \(viewModel.resultsDate)")
                    List {
                        Section {
                            ForEach(viewModel.dataSource, content: ResultRowView.init(viewModel:))
                        }
                    }.listStyle(.grouped)
                    Button("Back") {
                        showResults.toggle()
                    }
                    .buttonStyle(.bordered)
                    .tint(.green)
                }
            }
        }
    }
}
