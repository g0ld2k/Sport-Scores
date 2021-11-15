//
//  ScoresViewModelTests.swift
//  Sport ScoresTests
//
//  Created by Chris Golding on 11/14/21.
//

import XCTest
import Combine
import Mocker
@testable import Sport_Scores

class ScoresViewModelTests: XCTestCase {
    
    var viewModel: ScoresViewModel!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        let scoreFetcher = ScoreFetcher(session: urlSession)
        viewModel = ScoresViewModel(scoreFetcher: scoreFetcher)
    }
    
    override func setUpWithError() throws {
        let scoresData: [Mock.HTTPMethod : Data] = [
            .post : try! Data(contentsOf: ScoresTestsHelper.getJSON)
        ]
        let myScoresMock = Mock(url: ScoresTestsHelper.getURL,
                                dataType: .json,
                                statusCode: 200,
                                data: scoresData,
                                additionalHeaders: ["application/json": "Content-Type"])
        myScoresMock.register()
    }
    
    func testViewModelFetching() throws {
        viewModel.fetchScores()
        
        let expectation = XCTestExpectation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertEqual(self.viewModel.dataSource.count, 4)
                XCTAssertEqual(self.viewModel.scoreDate, "5/9/2020, 11:15 PM")

                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
    }
}
