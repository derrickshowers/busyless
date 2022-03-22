//
//  MonthViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 3/16/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import SwiftUI

class MonthViewModel: ObservableObject {
    // MARK: - Properties

    var slices: [(value: Double, color: Color, name: String)] {
        // TODO: Refactor to use something other than tuple
        var colorIndex = 0
        return categories.map {
            colorIndex += 1
            return (
                value: $0.timeSpentThisMonth,
                color: colors[colorIndex],
                name: $0.name ?? ""
            )
        }
    }

    var colors: [Color] = [.blue, .red, .orange, .green, .yellow]

    // MARK: - Initialization

    private let dataStore: DataStore
    @Published private var categories: [BLCategory]

    init(dataStore: DataStore) {
        self.dataStore = dataStore
        categories = dataStore.categoryStore.allCategories
    }
}
