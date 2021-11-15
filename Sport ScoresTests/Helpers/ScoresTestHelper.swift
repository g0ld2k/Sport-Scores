//
//  ScoresTestHelper.swift
//  Sport ScoresTests
//
//  Created by Chris Golding on 11/14/21.
//

import Foundation

class ScoresTestsHelper {
    public static let getURL = URL(string: "https://ancient-wood-1161.getsandbox.com:443/results")!
    public static let getJSON: URL = Bundle(for: ResultTest.self).url(forResource: "Sports-Scores", withExtension: "json")!
}
