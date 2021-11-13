//
//  ScoreRowView.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import SwiftUI

struct ScoreRowView: View {
    private let viewModel: ScoreRowViewModel
    
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
