//
//  ScoreRowViewModel.swift
//  Sport ScoresTests
//
//  Created by Chris Golding on 11/14/21.
//

import XCTest
@testable import Sport_Scores

class ScoreRowViewModelTest: XCTestCase {

    func testCreatingViewModel() throws {
        let publicationDate = Date(timeIntervalSince1970: 0)
        let winner = "Toad"
        let tournament = "Mushroom Cup"
        let seconds = 5.83
        
        let score = F1Score(publicationDate: publicationDate, winner: winner, tournament: tournament, seconds: seconds)
        let viewModel = ScoreRowViewModel(score: score)
        XCTAssertEqual(viewModel.id, "12/31/1969, 7:00 PMToad wins Mushroom Cup by 5.83 seconds")
        XCTAssertEqual(viewModel.summary, "Toad wins Mushroom Cup by 5.83 seconds")
        XCTAssertEqual(viewModel.date, "12/31/1969, 7:00 PM")
    }
}
