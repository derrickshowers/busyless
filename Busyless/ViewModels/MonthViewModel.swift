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

enum SelectedMonth {
    case currentMonth
    case lastMonth
}

class MonthViewModel: ObservableObject {
    // MARK: - Properties

    private var selectedMonthStartDate = Calendar.current.dateInterval(of: .month, for: Date())?.start ?? Date()

    @Published private var activities: [Activity]

    @Published var selectedMonth: SelectedMonth = .currentMonth {
        didSet {
            var date = Date()
            if selectedMonth == .lastMonth {
                date = Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date()
            }
            selectedMonthStartDate = Calendar.current.dateInterval(of: .month, for: date)?.start ?? Date()

            // TODO: Move to shared method
            if let fetchRequest = Activity.activitiesFetchRequest(forMonthStartingOn: selectedMonthStartDate) {
                fetchedResultsController = dataStore.fetch(using: fetchRequest)
            }
            activities = fetchedResultsController?.fetchedObjects ?? []
        }
    }

    var categories: [PieChartViewData] {
        var categories = Set<BLCategory>()
        activities.forEach { activity in
            guard let category = activity.category else { return }
            categories.insert(category)
        }

        // TODO: There's got to be a better way to do this. But for now...
        var colors: [Color] = [
            .blue,
            .red,
            .green,
            .yellow,
            .cyan,
            .pink,
            .brown,
            .mint,
            .orange,
            .blue,
            .red,
            .green,
            .yellow,
            .cyan,
            .pink,
            .brown,
            .mint,
            .orange,
            .blue,
            .red,
            .green,
            .yellow,
            .cyan,
            .pink,
            .brown,
            .mint,
            .orange,
        ]

        return categories.map { category in
            PieChartViewData(
                name: category.name ?? "Uncategorized",
                value: activities
                    .filter { $0.category == category }
                    .reduce(0) { $0 + $1.duration },
                color: colors.popLast() ?? .black
            )
        }
    }

    // MARK: - Initialization

    private let dataStore: DataStore
    private var fetchedResultsController: NSFetchedResultsController<Activity>?

    init(dataStore: DataStore) {
        self.dataStore = dataStore
        if let fetchRequest = Activity.activitiesFetchRequest(forMonthStartingOn: selectedMonthStartDate) {
            fetchedResultsController = dataStore.fetch(using: fetchRequest)
        }
        activities = fetchedResultsController?.fetchedObjects ?? []
    }
}
