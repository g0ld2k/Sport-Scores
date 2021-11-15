//
//  ScoreFetcherTests.swift
//  Sport ScoresTests
//
//  Created by Chris Golding on 11/14/21.
//

import XCTest
import Combine
import Mocker
@testable import Sport_Scores

class ScoreFetcherTests: XCTestCase {
    
    func testFetchingScores() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        let scoreFetcher = ScoreFetcher(session: urlSession)
        var token: AnyCancellable!
            
        let scoresData: [Mock.HTTPMethod : Data] = [
            .post : try! Data(contentsOf: ScoresTestsHelper.getJSON)
        ]
        let myScoresMock = Mock(url: ScoresTestsHelper.getURL,
                                dataType: .json,
                                statusCode: 200,
                                data: scoresData,
                                additionalHeaders: ["application/json": "Content-Type"])
        myScoresMock.register()
        
        let testExpectation = expectation(description: "callback called")
        token = scoreFetcher.latestScores()
            .sink(receiveCompletion: { value in
                switch value {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    XCTFail(error.localizedDescription)
                    testExpectation.fulfill()
                case .finished:
                    testExpectation.fulfill()
                }
            }, receiveValue: { scores in
                XCTAssertNotNil(scores)
                XCTAssertEqual(scores.count, 4)
                print("Scores: \(scores)")
                XCTAssertEqual(scores[0].winner, "Rafael Nadal")
                guard let nbaScore = scores[3] as? NbaScore else {
                    XCTFail("Unable to cast Score")
                    return
                }
                XCTAssertEqual(nbaScore.mvp, "Lebron James")
            })
        
        waitForExpectations(timeout: 20, handler: nil)
    }
}
