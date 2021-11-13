//
//  ScoreRowView.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import SwiftUI

struct ScoreRowView: View {
    private let score: Score
    init(score: Score) {
        self.score = score
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 15) {
                Text(score.winner)
                    .font(.system(size: 18))
                    .foregroundColor(Color.blue)
            }
        }
    }
}
