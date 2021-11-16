//
//  ResultsViewModelTests.swift
//  Sport ScoresTests
//
//  Created by Chris Golding on 11/14/21.
//

import XCTest
import Combine
import Mocker
@testable import Sport_Scores

class ResultsViewModelTests: XCTestCase {
    
    var viewModel: ResultsViewModel!
    
    override func setUp() {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        let resultsFetcher = ResultsFetcher(session: urlSession)
        viewModel = ResultsViewModel(resultsFetcher: resultsFetcher)
    }
    
    override func setUpWithError() throws {
        let resultsData: [Mock.HTTPMethod : Data] = [
            .post : try! Data(contentsOf: ScoresTestsHelper.getJSON)
        ]
        let myResultsMock = Mock(url: ScoresTestsHelper.getURL,
                                dataType: .json,
                                statusCode: 200,
                                data: resultsData,
                                additionalHeaders: ["application/json": "Content-Type"])
        myResultsMock.register()
    }
    
    func testViewModelFetching() throws {
        viewModel.fetchResults()
        
        let expectation = XCTestExpectation()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                XCTAssertEqual(self.viewModel.dataSource.count, 4)
                XCTAssertEqual(self.viewModel.resultsDate, "2020-05-09")

                expectation.fulfill()
            }
            wait(for: [expectation], timeout: 1.0)
    }
}
