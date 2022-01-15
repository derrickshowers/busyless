//
//  LogViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 1/12/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation
import BusylessDataLayer
import CoreData
import SwiftUI

class LogViewModel: ObservableObject {

    // MARK: - Properties

    @Published var activities: [[Activity]]
    @AppStorage("shouldShowLogOnboarding") var shouldShowLogOnboarding = true

    var containsUncategorizedActivities: Bool {
        let uncategorizedActivityCount = activities.flatMap({ $0 }).reduce(0) {
            $0 + ($1.category == nil ? 1 : 0)
        }
        return uncategorizedActivityCount > 0
    }

    // MARK: - Initialization

    private let dataStore: DataStore

    init(dataStore: DataStore) {
        self.dataStore = dataStore
        self.activities = dataStore.activityStore.allActivitiesGroupedByDate
    }

    // MARK: - Public Methods

    func saveAll() {
        Activity.save(with: dataStore.context)
    }

    func deleteActivity(_ activity: Activity) {
        activity.deleteAndSave(with: dataStore.context)
    }

    func duplicateActivity(_ activity: Activity) {
        activity.copy()
        self.saveAll()
    }

    func sectionHeader(for section: [Activity]) -> String {
        if let date = section[0].createdAt {
            return date.prettyDate
        }
        return "Unknown Date"
    }

    func newCategory(for activities: Set<Activity>) -> Binding<BLCategory?> {
        Binding<BLCategory?>(
            get: { nil },
            set: { category in
                activities.forEach { $0.category = category }
                self.saveAll()
            }
        )
    }
}
