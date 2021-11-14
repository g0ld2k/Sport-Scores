//
//  Score.swift
//  Sport ScoresTests
//
//  Created by Chris Golding on 11/13/21.
//

import XCTest
@testable import Sport_Scores

class ScoreTest: XCTestCase {

    func testScore() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Kermit"
        let tournament = "Swimming"
        
        let score = Score(publicationDate: publicationDate, winner: winner, tournament: tournament)
        XCTAssertEqual(score.summary(), "\(tournament): \(winner) wins")
        
        
        let score2 = Score(publicationDate: publicationDate, winner: winner, tournament: tournament + "s")
        XCTAssertEqual(score2.summary(), "\(tournament)s: \(winner) wins")
        
        XCTAssert(score == score)
        XCTAssert(score != score2)
    }
    
    func testF1Score() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Toad"
        let tournament = "Mushroom Cup"
        let seconds = 5.83
        
        let score = F1Score(publicationDate: publicationDate, winner: winner, tournament: tournament, seconds: seconds)
        XCTAssertEqual(score.summary(), "\(winner) wins \(tournament) by \(seconds) seconds")
    }
    
    func testNbaScore() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Mario Squad"
        let tournament = "Goomba B-Ball"
        let looser = "Turtle Troopers"
        let gameNumber = 4
        let mvp = "Luigi"
        
        let score = NbaScore(publicationDate: publicationDate, winner: winner, tournament: tournament, looser: looser, gameNumber: gameNumber, mvp: mvp)
        XCTAssertEqual(score.summary(), "\(mvp) leads \(winner) to game \(gameNumber) in the \(tournament)")
        
    }
    
    func testTennisScore() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Peach"
        let tournament = "Koopa Aces"
        let looser = "Goomba"
        let numberOfSets = 4
        
        let score = TennisScore(publicationDate: publicationDate, winner: winner, tournament: tournament, looser: looser, numberOfSets: numberOfSets)
        XCTAssertEqual(score.summary(), "\(tournament): \(winner) wins against \(looser) in \(numberOfSets) sets")
    }
}
