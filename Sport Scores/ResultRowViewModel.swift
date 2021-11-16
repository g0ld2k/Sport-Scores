//
//  ResultRowViewModel.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/13/21.
//

import Foundation

/// Result Row View Model
struct ResultRowViewModel: Identifiable {
    private let result: Result
    
    var id: String {
        return date + summary
    }
    
    var summary: String {
        return result.summary()
    }
    
    var date: String {
        return result.publicationDate.formatted()
    }
    
    /// Default init
    /// - Parameter result: result to feed view model
    init(result: Result) {
        self.result = result
    }
}
