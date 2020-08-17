//
//  CategoryTests.swift
//  TimeBudgetTests
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import XCTest
import CoreData
@testable import TimeBudget

class CategoryTests: XCTestCase {

    private var category: TimeBudget.Category?

    override func setUpWithError() throws {
        category = Category.mockCategory
    }

    func testTimeSpentDuration() throws {
        let categoryWithPastActivities = Category.mockCategoryWithPastActivities
        XCTAssertTrue(category?.timeSpentDuration == 3 * TimeInterval.oneHour)
        XCTAssertTrue(categoryWithPastActivities.timeSpentDuration == 0)
    }

}
