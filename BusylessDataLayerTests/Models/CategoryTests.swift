//
//  CategoryTests.swift
//  BusylessTests
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import XCTest
import CoreData
@testable import BusylessDataLayer

class CategoryTests: XCTestCase {

    private var category: BLCategory?

    override func setUpWithError() throws {
        category = BLCategory.mockCategory()
    }

    func testTimeSpentDuration() throws {
        let categoryWithPastActivities = BLCategory.mockCategoryWithPastActivities()
        XCTAssertTrue(category?.timeSpentDuration == 3 * 3600)
        XCTAssertTrue(categoryWithPastActivities.timeSpentDuration == 0)
    }

}
