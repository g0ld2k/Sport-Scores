//
//  F1Score.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/14/21.
//

import Foundation

/// Results for F1 Race
class F1Result: Result {
    private(set) var seconds: Double
    
    /// Default init
    /// - Parameters:
    ///   - publicationDate: date of result
    ///   - winner: winner of race
    ///   - tournament: event name
    ///   - seconds: number of seconds winner won by
    init(publicationDate: Date, winner: String, tournament: String, seconds: Double) {
        self.seconds = seconds
        
        super.init(publicationDate: publicationDate, winner: winner, tournament: tournament)
    }
    
    /// Hasher for F1Scores
    /// - Parameter hasher:
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(seconds)
    }
    
    /// Generates summary for result
    /// - Returns: result summary
    override func summary() -> String {
        // Lewis Hamilton wins Silverstone Grand Prix by 5.856 seconds
        return "\(winner) wins \(tournament) by \(seconds) seconds"
    }
}
