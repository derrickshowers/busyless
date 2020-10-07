//
//  TimeIntervalTests.swift
//  BusylessTests
//
//  Created by Derrick Showers on 10/6/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import XCTest
@testable import Busyless

class TimeIntervalTests: XCTestCase {

    func testConversionToHoursAndMinutes() throws {
        var duration = TimeInterval(1 * TimeInterval.oneHour)
        var durationInHoursAndMinutes = duration.asHoursAndMinutes
        XCTAssertTrue(durationInHoursAndMinutes.hours == 1)
        XCTAssertTrue(durationInHoursAndMinutes.minutes == 0)

        duration = TimeInterval(2 * TimeInterval.oneHour)
        durationInHoursAndMinutes = duration.asHoursAndMinutes
        XCTAssertTrue(durationInHoursAndMinutes.hours == 2)
        XCTAssertTrue(durationInHoursAndMinutes.minutes == 0)

        duration = TimeInterval(2.25 * TimeInterval.oneHour)
        durationInHoursAndMinutes = duration.asHoursAndMinutes
        XCTAssertTrue(durationInHoursAndMinutes.hours == 2)
        XCTAssertTrue(durationInHoursAndMinutes.minutes == 15)

        duration = TimeInterval(1.75 * TimeInterval.oneHour)
        durationInHoursAndMinutes = duration.asHoursAndMinutes
        XCTAssertTrue(durationInHoursAndMinutes.hours == 1)
        XCTAssertTrue(durationInHoursAndMinutes.minutes == 45)
    }

    func testConversionFromHoursAndMinutes() throws {
        var duration = TimeInterval.calculateTotalDurationFrom(hours: 1, minutes: 0)
        XCTAssertTrue(duration == 1 * TimeInterval.oneHour)

        duration = TimeInterval.calculateTotalDurationFrom(hours: 1, minutes: 15)
        XCTAssertTrue(duration == 1.25 * TimeInterval.oneHour)

        duration = TimeInterval.calculateTotalDurationFrom(hours: 2, minutes: 30)
        XCTAssertTrue(duration == 2.5 * TimeInterval.oneHour)
    }
}
