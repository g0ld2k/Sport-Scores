//
//  ResultsTest.swift
//  Sport ScoresTests
//
//  Created by Chris Golding on 11/13/21.
//

import XCTest
@testable import Sport_Scores

class ResultTest: XCTestCase {
    func testResult() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Kermit"
        let tournament = "Swimming"

        let result = Result(publicationDate: publicationDate, winner: winner, tournament: tournament)
        XCTAssertEqual(result.summary(), "\(tournament): \(winner) wins")

        let result2 = Result(publicationDate: publicationDate, winner: winner, tournament: tournament + "s")
        XCTAssertEqual(result2.summary(), "\(tournament)s: \(winner) wins")

        XCTAssert(result == result)
        XCTAssert(result != result2)
    }

    func testF1Result() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Toad"
        let tournament = "Mushroom Cup"
        let seconds = 5.83

        let result = F1Result(publicationDate: publicationDate,
                              winner: winner,
                              tournament: tournament,
                              seconds: seconds)
        XCTAssertEqual(result.summary(), "\(winner) wins \(tournament) by \(seconds) seconds")
    }

    func testNbaResult() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Mario Squad"
        let tournament = "Goomba B-Ball"
        let looser = "Turtle Troopers"
        let gameNumber = 4
        let mvp = "Luigi"

        let result = NbaResult(publicationDate: publicationDate,
                               winner: winner,
                               tournament: tournament,
                               looser: looser,
                               gameNumber: gameNumber,
                               mvp: mvp)
        XCTAssertEqual(result.summary(), "\(mvp) leads \(winner) to game \(gameNumber) in the \(tournament)")

    }

    func testTennisResult() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Peach"
        let tournament = "Koopa Aces"
        let looser = "Goomba"
        let numberOfSets = 4

        let result = TennisResult(publicationDate: publicationDate,
                                  winner: winner,
                                  tournament: tournament,
                                  looser: looser,
                                  numberOfSets: numberOfSets)
        XCTAssertEqual(result.summary(), "\(tournament): \(winner) wins against \(looser) in \(numberOfSets) sets")
    }
}
