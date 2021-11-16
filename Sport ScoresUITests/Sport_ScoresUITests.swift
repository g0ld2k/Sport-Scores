//
//  Sport_ScoresUITests.swift
//  Sport ScoresUITests
//
//  Created by Chris on 11/10/21.
//

import XCTest

class Sport_ScoresUITests: XCTestCase {

    func testLaunchingAndNavigating() throws {
        let app = XCUIApplication()
        app.launch()

        app.buttons["Get Results Button"].tap()
        sleep(2)

        XCTAssertTrue(app.tables.cells.count == 4)
        XCTAssertTrue(app.tables.cells.element(boundBy: 0)
                        .staticTexts["Roland Garros: Rafael Nadal wins against Schwartzman  in 3 sets"]
                        .exists)
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
