//
//  ResultsFetcherTests.swift
//  Sport ScoresTests
//
//  Created by Chris Golding on 11/14/21.
//

import XCTest
import Combine
import Mocker
@testable import Sport_Scores

class ScoreFetcherTests: XCTestCase {
    
    func testFetchingResults() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockingURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        
        let resultFetcher = ResultsFetcher(session: urlSession)
        var token: AnyCancellable!
            
        let resultsData: [Mock.HTTPMethod : Data] = [
            .post : try! Data(contentsOf: ScoresTestsHelper.getJSON)
        ]
        let myResultsMock = Mock(url: ScoresTestsHelper.getURL,
                                dataType: .json,
                                statusCode: 200,
                                data: resultsData,
                                additionalHeaders: ["application/json": "Content-Type"])
        myResultsMock.register()
        
        let testExpectation = expectation(description: "callback called")
        token = resultFetcher.latestResults()
            .sink(receiveCompletion: { value in
                switch value {
                case .failure(let error):
                    XCTAssertNotNil(error)
                    XCTFail(error.localizedDescription)
                    testExpectation.fulfill()
                case .finished:
                    testExpectation.fulfill()
                }
            }, receiveValue: { results in
                XCTAssertNotNil(results)
                XCTAssertEqual(results.count, 4)
                XCTAssertEqual(results[0].winner, "Rafael Nadal")
                guard let nbaResult = results[3] as? NbaResult else {
                    XCTFail("Unable to cast Result")
                    return
                }
                XCTAssertEqual(nbaResult.mvp, "Lebron James")
            })
        
        waitForExpectations(timeout: 20, handler: nil)
    }
}
