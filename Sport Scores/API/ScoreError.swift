//
//  ScoreError.swift
//  Sport Scores
//
//  Created by Chris Golding on 11/13/21.
//

import Foundation

enum ScoreError: Error {
  case parsing(description: String)
  case network(description: String)
}
