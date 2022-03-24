//
//  MonthViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 3/16/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import CoreData
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

    private var selectedMonthStartDate = Calendar.current.dateInterval(of: .month, for: Date())?.start ?? Date()

    // MARK: - Initialization

    private let dataStore: DataStore
    private var fetchedResultsController: NSFetchedResultsController<Activity>?
    @Published private var activities: [Activity]

    private var categories: [BLCategory] {
        var categories = Set<BLCategory>()
        activities.forEach { activity in
            guard let category = activity.category else { return }
            categories.insert(category)
        }
        return Array(categories)
    }

    init(dataStore: DataStore) {
        self.dataStore = dataStore
        if let fetchRequest = Activity.activitiesFetchRequest(forMonthStartingOn: selectedMonthStartDate) {
            fetchedResultsController = dataStore.fetch(using: fetchRequest)
        }
        activities = fetchedResultsController?.fetchedObjects ?? []
    }
}
