//
//  LogViewTests.swift
//  BusylessTests
//
//  Created by Derrick Showers on 2/5/21.
//  Copyright © 2021 Derrick Showers. All rights reserved.
//

@testable import Busyless
@testable import BusylessDataLayer
import SwiftUI
import ViewInspector
import XCTest

extension LogView: Inspectable {}

class LogViewTests: XCTestCase {
    func DISABLEtestActivity() {
        let dataStoreMock = DataStoreMock()
        var logView = LogView.forTesting()
        let expectation = logView.on(\.didAppear) { view in
            let labelView = try? view.find(ViewType.List.self).forEach(0).section(0).forEach(0).button(0).labelView()
            let mockActivity = dataStoreMock.dataStore.activityStore.allActivities.first
            XCTAssertEqual(try labelView?.vStack().text(0).string(), mockActivity?.name)
            XCTAssertEqual(try labelView?.vStack().hStack(1).text(0).string(), mockActivity?.category?.name)
            XCTAssertEqual(
                try labelView?.vStack().hStack(1).text(3).string(),
                mockActivity?.duration.hoursMinutesString
            )
        }
        ViewHosting.host(view: logView)
        wait(for: [expectation], timeout: 0.1)
    }
}
