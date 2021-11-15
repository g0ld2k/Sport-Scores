//
//  Score.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import Foundation

/// Base Score Class
class Score: Hashable {
    
    private(set) var publicationDate: Date
    private(set) var winner: String
    private(set) var tournament: String
    
    /// Default init
    /// - Parameters:
    ///   - publicationDate: date of score results
    ///   - winner: winner of event
    ///   - tournament: event name
    init(publicationDate: Date, winner: String, tournament: String) {
        self.publicationDate = publicationDate
        self.winner = winner
        self.tournament = tournament
    }
    
    /// Comparitor funciton
    /// - Returns: comparision between score objects
    static func == (lhs: Score, rhs: Score) -> Bool {
        return lhs.publicationDate == rhs.publicationDate && lhs.tournament == rhs.tournament && lhs.winner == rhs.winner
    }
    
    /// Score Hasher
    /// - Parameter hasher:
    func hash(into hasher: inout Hasher) {
        hasher.combine(publicationDate)
        hasher.combine(winner)
        hasher.combine(tournament)
    }
    
    /// Generates a summary of the score results
    /// - Returns: summary of score results
    func summary() -> String {
        return "\(tournament): \(winner) wins"
    }
}
