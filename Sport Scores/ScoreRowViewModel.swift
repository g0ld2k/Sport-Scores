//
//  ScoreRowViewModel.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/13/21.
//

import Foundation

struct ScoreRowViewModel: Identifiable {
    private let item: Score
    
    var id: String {
        return date + summary
    }
    
    var summary: String {
        return item.summary()
    }
    
    var date: String {
        return item.publicationDate.formatted()
    }
    
    init(item: Score) {
        self.item = item
    }
}
