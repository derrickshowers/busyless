//
//  CategoryTests.swift
//  BusylessTests
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import XCTest
import CoreData
@testable import Busyless

class CategoryTests: XCTestCase {

    private var category: Busyless.Category?

    override func setUpWithError() throws {
        category = Category.mockCategory()
    }

    func testTimeSpentDuration() throws {
        let categoryWithPastActivities = Category.mockCategoryWithPastActivities()
        XCTAssertTrue(category?.timeSpentDuration == 3 * TimeInterval.oneHour)
        XCTAssertTrue(categoryWithPastActivities.timeSpentDuration == 0)
    }

}
