//
//  ScoreRowViewModel.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/13/21.
//

import Foundation

/// Score Row View Model
struct ScoreRowViewModel: Identifiable {
    private let score: Score
    
    var id: String {
        return date + summary
    }
    
    var summary: String {
        return score.summary()
    }
    
    var date: String {
        return score.publicationDate.formatted()
    }
    
    /// Default init
    /// - Parameter item: score
    init(score: Score) {
        self.score = score
    }
}
