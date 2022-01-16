//
//  DayViewTests.swift
//  BusylessTests
//
//  Created by Derrick Showers on 1/23/21.
//  Copyright © 2021 Derrick Showers. All rights reserved.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import Busyless
@testable import BusylessDataLayer

extension DayView: Inspectable { }
extension AddButton: Inspectable { }
extension CategoryRow: Inspectable { }

class DayViewTests: XCTestCase {

    func DISABLEtestAddButton() {
        var dayView = DayView()
        let expectation = dayView.on(\.didAppear) { view in
            let addButton = try? view.find(button: "+")
            XCTAssertNotNil(addButton)
            XCTAssertEqual(try view.actualView().activeSheet, nil)
        }
        ViewHosting.host(view: dayView)
        wait(for: [expectation], timeout: 0.1)
    }

    func DISABLEtestCategory() {
        let dataStoreMock = DataStoreMock()
        var dayView = DayView()
        let expectation = dayView.on(\.didAppear) { view in
            XCTAssertEqual(try view.find(CategoryRow.self).hStack().vStack(0).text(0).string(), dataStoreMock.dataStore.categoryStore.allCategories.first?.name)
        }
        ViewHosting.host(view: dayView
                            .environment(\.managedObjectContext, dataStoreMock.context)
                            .environment(\.dataStore, dataStoreMock.dataStoreObservable))
        wait(for: [expectation], timeout: 0.1)
    }
}
