//
//  Responses.swift
//  Sport Scores
//
//  Created by Chris on 11/11/21.
//

import Foundation

// MARK: - SportsScoresResponse
struct SportsScoresResponse: Codable {
    let f1Results: [ApiF1Result]
    let nbaResults: [ApiNbaResult]
    let tennisResults: [ApiTennisResult]

    enum CodingKeys: String, CodingKey {
        case f1Results, nbaResults
        case tennisResults = "Tennis"
    }
}

// MARK: - F1Result
struct ApiF1Result: Codable, Hashable {
    let publicationDate: Date
    let seconds: Double
    let tournament, winner: String
}

// MARK: - NbaResult
struct ApiNbaResult: Codable {
    let gameNumber: Int
    let publicationDate: Date
    let looser, mvp, tournament: String
    let winner: String
}

// MARK: - Tennis
struct ApiTennisResult: Codable {
    let looser: String
    let numberOfSets: Int
    let publicationDate: Date
    let tournament, winner: String
}

