//
//  Score.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/12/21.
//

import Foundation

class Score: Hashable {

    private(set) var publicationDate: Date
    private(set) var winner: String
    private(set) var tournament: String
    
    init(publicationDate: Date, winner: String, tournament: String) {
        self.publicationDate = publicationDate
        self.winner = winner
        self.tournament = tournament
    }
    
    static func == (lhs: Score, rhs: Score) -> Bool {
        return lhs.publicationDate == rhs.publicationDate && lhs.tournament == rhs.tournament && lhs.winner == rhs.winner
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(publicationDate)
        hasher.combine(winner)
        hasher.combine(tournament)
    }
}

class F1Score: Score {
    private(set) var seconds: Double
    
    init(publicationDate: Date, winner: String, tournament: String, seconds: Double) {
        self.seconds = seconds
        
        super.init(publicationDate: publicationDate, winner: winner, tournament: tournament)
    }
    
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(seconds)
    }
}

class NbaScore: Score {
    private(set) var looser: String
    private(set) var gameNumber: Int
    private(set) var mvp: String
    
    init(publicationDate: Date, winner: String, tournament: String, looser: String, gameNumber: Int, mvp: String) {
        
        self.looser = looser
        self.gameNumber = gameNumber
        self.mvp = mvp
        
        super.init(publicationDate: publicationDate, winner: winner, tournament: tournament)
        
    }
    
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(looser)
        hasher.combine(gameNumber)
        hasher.combine(mvp)
    }
}

class TennisScore: Score {
    
    private(set) var looser: String
    private(set) var numberOfSets: Int
    
    init(publicationDate: Date, winner: String, tournament: String, looser: String, numberOfSets: Int) {
        self.looser = looser
        self.numberOfSets = numberOfSets
        
        super.init(publicationDate: publicationDate, winner: winner, tournament: tournament)
    }
    
    override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(looser)
        hasher.combine(numberOfSets)
    }
}
