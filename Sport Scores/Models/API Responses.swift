//
//  Responses.swift
//  Sport Scores
//
//  Created by Chris on 11/11/21.
//

import Foundation

// MARK: - SportsScoresResponse
struct SportsScoresResponse: Codable {
    let f1Results: [F1Result]
    let nbaResults: [NbaResult]
    let tennisResults: [Tennis]

    enum CodingKeys: String, CodingKey {
        case f1Results, nbaResults
        case tennisResults = "Tennis"
    }
}

// MARK: - F1Result
struct F1Result: Codable, Hashable {
    let publicationDate: Date
    let seconds: Double
    let tournament, winner: String
}

// MARK: - NbaResult
struct NbaResult: Codable {
    let gameNumber: Int
    let publicationDate: Date
    let looser, mvp, tournament: String
    let winner: String
}

// MARK: - Tennis
struct Tennis: Codable {
    let looser: String
    let numberOfSets: Int
    let publicationDate: Date
    let tournament, winner: String
}

