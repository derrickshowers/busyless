//
//  LogViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 1/12/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import CoreData
import Foundation
import SwiftUI

class LogViewModel: ObservableObject {
    // MARK: - Properties

    @Published var activities: [[Activity]]
    @AppStorage("shouldShowLogOnboarding") var shouldShowLogOnboarding = true

    var containsUncategorizedActivities: Bool {
        let uncategorizedActivityCount = activities.flatMap { $0 }.reduce(0) {
            $0 + ($1.category == nil ? 1 : 0)
        }
        return uncategorizedActivityCount > 0
    }

    // MARK: - Initialization

    private let dataStore: DataStore

    init(dataStore: DataStore) {
        self.dataStore = dataStore
        activities = dataStore.activityStore.allActivitiesGroupedByDate
    }

    // MARK: - Public Methods

    func saveAll() {
        Activity.save(with: dataStore.context)
    }

    func deleteActivity(_ activity: Activity) {
        activity.deleteAndSave(with: dataStore.context)
    }

    func set(durationInHours: Double, for activity: Activity) {
        activity.duration = durationInHours * TimeInterval.oneHour
        saveAll()
    }

    func duplicateActivity(_ activity: Activity) {
        _ = activity.copy()
        saveAll()
    }

    func copyName(_ activity: Activity) {
        UIPasteboard.general.string = activity.name
    }

    func roundTime(_ activity: Activity) {
        activity.createdAt = activity.createdAt?.round(to: 15, .minute)
        saveAll()
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
