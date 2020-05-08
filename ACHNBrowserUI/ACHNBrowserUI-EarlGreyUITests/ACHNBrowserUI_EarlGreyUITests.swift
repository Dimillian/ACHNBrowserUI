//
//  ACHNBrowserUI_EarlGreyUITests.swift
//  ACHNBrowserUI-EarlGreyUITests
//
//  Created by Peter Steinberger on 08.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import XCTest
import EarlGrey

class ACHNBrowserUI_EarlGreyUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEarlGreyAllTabBarButtons() throws {

        EarlGrey.element("Catalog").tap()
        EarlGrey.element("Turnips").tap()
        EarlGrey.element("Villagers").tap()
        EarlGrey.element("My Stuff").tap()
        EarlGrey.element("Dashboard").tap()
        EarlGrey.element("Bugs").tap()

    }


}
