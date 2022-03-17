//
//  MainViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 1/13/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation

class MainViewModel: ObservableObject {
    let addNewActivityView: AddNewActivityView
    let logView: LogView
    let monthView: MonthView

    init(addNewActivityView: AddNewActivityView, logView: LogView, monthView: MonthView) {
        self.addNewActivityView = addNewActivityView
        self.logView = logView
        self.monthView = monthView
    }
}
