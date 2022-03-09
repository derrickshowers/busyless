//
//  CategoryTests.swift
//  BusylessTests
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

@testable import BusylessDataLayer
import CoreData
import XCTest

class CategoryTests: XCTestCase {
    private var category: BLCategory?

    override func setUpWithError() throws {
        category = BLCategory.mockCategory()
    }

    func testTimeSpentToday() throws {
        let categoryWithPastActivities = BLCategory.mockCategoryWithPastActivities()
        XCTAssertTrue(category?.timeSpentToday == 3 * 3600)
        XCTAssertTrue(categoryWithPastActivities.timeSpentToday == 0)
    }
}
