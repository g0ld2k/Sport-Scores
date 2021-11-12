//
//  Responses.swift
//  Sport Scores
//
//  Created by Chris on 11/11/21.
//

import Foundation

struct SportsScoresResponse: Codable {
    let f1Results: [F1Result]
    let nbaResults: [NBAResult]
    let tennis: [TennisResult]
    
    struct F1Result: Codable {
        let publicationDate: Date
        let seconds: Double
        let tournament: String
        let winner: String
    }
    
    struct NBAResult: Codable {
        let gameNumber: Int
        let looser: String
        let mvp: String
        let publicationDate: Date
        let tournament: String
        let winner: String
    }
    
    struct TennisResult: Codable {
        let looser: String
        let numberOfSets: Int
        let publicationDate: Date
        let tournament: String
        let winner: String
    }
    
    enum CodingKeys: String, CodingKey {
        case f1Results, nbaResults
        case tennis = "Tennis"
    }
}


