//
//  TennisScore.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/14/21.
//

import Foundation

/// Tennis Event Class
class TennisScore: Score {
    
    private(set) var looser: String
    private(set) var numberOfSets: Int
    
    /// Default init
    /// - Parameters:
    ///   - publicationDate: event date
    ///   - winner: event winner
    ///   - tournament: event name
    ///   - looser: event looser
    ///   - numberOfSets: number of sets in event
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
    
    /// Generates summary of event
    /// - Returns: event summary
    override func summary() -> String {
        // Roland Garros: Novak Djokovic wins against Schwartzman in 5 sets
        return "\(tournament): \(winner) wins against \(looser) in \(numberOfSets) sets"
    }
}
