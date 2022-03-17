//
//  MonthViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 3/16/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import Foundation

class MonthViewModel: ObservableObject {
    // MARK: - Initialization

    private let dataStore: DataStore

    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
}
