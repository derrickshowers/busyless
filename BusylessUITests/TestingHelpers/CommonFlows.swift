//
//  CommonFlows.swift
//  BusylessUITests
//
//  Created by Derrick Showers on 1/23/21.
//  Copyright © 2021 Derrick Showers. All rights reserved.
//

import XCTest

struct CommonFlows {
    static func relaunch(testingApp: XCUIApplication) {
        testingApp.terminate()
        testingApp.activate()
    }

    static func addANewActivity(activityName: String, testingApp: XCUIApplication) {
        relaunch(testingApp: testingApp)

        // Open AddNewActivityView
        testingApp.buttons["Add a new activity"].tap()

        // Enter an activity
        let textField = testingApp.tables.textFields["Activity Name"]
        textField.tap()
        textField.typeText(activityName)

        // Tap done to leave AddNewActivityView and save activity
        testingApp.navigationBars["Log New Activity"].buttons["Done"].tap()
    }
}
