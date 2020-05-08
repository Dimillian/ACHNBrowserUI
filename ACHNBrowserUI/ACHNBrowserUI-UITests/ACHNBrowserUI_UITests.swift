//
//  ACHNBrowserUI_UITests.swift
//  ACHNBrowserUI-UITests
//
//  Created by Peter Steinberger on 08.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import XCTest

class ACHNBrowserUI_UITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
    }

    func testTapAllTabBarButtons() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Simply iterate over all tabs
        let tabBarsQuery = XCUIApplication().tabBars
        tabBarsQuery.buttons["Catalog"].tap()
        tabBarsQuery.buttons["Turnips"].tap()
        tabBarsQuery.buttons["Villagers"].tap()
        tabBarsQuery.buttons["My Stuff"].tap()
        tabBarsQuery.buttons["Dashboard"].tap()

        // Select bugs from the table
        app.tables.buttons["Bugs"].tap()
    }

}
