//
//  ScoreError.swift
//  Sport Scores
//
//  Created by Chris on 11/11/21.
//

import Foundation

enum ScoreError: Error {
    case parsing(description: String)
    case network(description: String)
}
