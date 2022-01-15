//
//  BusylessUITests.swift
//  BusylessUITests
//
//  Created by Derrick Showers on 8/8/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import XCTest

class BusylessUITests: XCTestCase {

    let app = XCUIApplication()

    override func setUp() {
        app.activate()
    }

    func DISABLEDtestAddingNewActivity() {
        // Add the activity
        let activityName = "New Activity"
        CommonFlows.addANewActivity(activityName: activityName, testingApp: app)

        // Verify the activity was added
        app.navigationBars["Today"].buttons["Back"].tap()
        app.buttons["Activity Log"].tap()
        XCTAssertTrue(app.tables.cells.firstMatch.label.contains(activityName))
    }

    // TODO: Figure out why this is breaking on CI
    func DISABLEDtestDeletingNewActivity() {
        // Add the activity
        let activityName = "New Activity To Delete"
        CommonFlows.addANewActivity(activityName: activityName, testingApp: app)

        // Verify the activity was added
        app.navigationBars["Today"].buttons["Back"].tap()
        app.buttons["Activity Log"].tap()
        XCTAssertTrue(app.tables.cells.firstMatch.label.contains(activityName))

        // Delete the activity
        app.tables.cells.firstMatch.swipeLeft()
        app.tables.cells.firstMatch.buttons["Delete"].tap()
        XCTAssertFalse(app.tables.cells.firstMatch.label.contains(activityName))
    }
}
