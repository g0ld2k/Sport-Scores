//
//  TennisScore.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/14/21.
//

import Foundation

/// Result of Tennis Match
class TennisResult: Result {
    
    private(set) var looser: String
    private(set) var numberOfSets: Int
    
    /// Default init
    /// - Parameters:
    ///   - publicationDate: result date
    ///   - winner: match winner
    ///   - tournament: event name
    ///   - looser: match looser
    ///   - numberOfSets: number of sets in match
    init(publicationDate: Date, winner: String, tournament: String, looser: String, numberOfSets: Int) {
        self.looser = looser
        self.numberOfSets = numberOfSets
        
        super.init(publicationDate: publicationDate, winner: winner, tournament: tournament)
    }
    
    /// Tennis hasher
    /// - Parameter hasher:
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(looser)
        hasher.combine(numberOfSets)
    }
    
    /// Generates summary of result
    /// - Returns: result summary
    override func summary() -> String {
        // Roland Garros: Novak Djokovic wins against Schwartzman in 5 sets
        return "\(tournament): \(winner) wins against \(looser) in \(numberOfSets) sets"
    }
}
