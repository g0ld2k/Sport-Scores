//
//  NbaScore.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/14/21.
//

import Foundation

/// Results of NBA Game
class NbaResult: Result {
    private(set) var looser: String
    private(set) var gameNumber: Int
    private(set) var mvp: String
    
    /// Default init
    /// - Parameters:
    ///   - publicationDate: result date
    ///   - winner: winner of game
    ///   - tournament: game name
    ///   - looser: who lost game
    ///   - gameNumber: game number
    ///   - mvp: most valuable player of game
    init(publicationDate: Date, winner: String, tournament: String, looser: String, gameNumber: Int, mvp: String) {
        
        self.looser = looser
        self.gameNumber = gameNumber
        self.mvp = mvp
        
        super.init(publicationDate: publicationDate, winner: winner, tournament: tournament)
    }
    
    /// NBA Score hasher
    /// - Parameter hasher:
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(looser)
        hasher.combine(gameNumber)
        hasher.combine(mvp)
    }
    
    /// Summary of NBA Game
    /// - Returns: game summary
    override func summary() -> String {
        // Lebron James leads Lakers to game 4 win in the NBA playoffs
        return "\(mvp) leads \(winner) to game \(gameNumber) in the \(tournament)"
    }
}
