//
//  ScoreRowView.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import SwiftUI

/// Score Row View
struct ScoreRowView: View {
    private let viewModel: ScoreRowViewModel
    
    /// Deault init
    /// - Parameter viewModel: view model to drive view
    init(viewModel: ScoreRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(viewModel.summary)
                    .font(.system(size: 18))
                    .foregroundColor(Color.blue)
                Text(viewModel.date)
                    .font(.footnote)
                    .foregroundColor(Color.black)
            }
        }
    }
}
