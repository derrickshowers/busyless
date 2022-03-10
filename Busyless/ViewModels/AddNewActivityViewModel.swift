//
//  AddNewActivityViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 1/18/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import CoreData
import Foundation
import Intents

class AddNewActivityViewModel: ObservableObject {
    // MARK: - Properties

    @Published var name = ""
    @Published var category: BLCategory?
    @Published var hoursDuration = 0
    @Published var minutesDuration = 15
    @Published var createdAt = Date()
    @Published var notes = ""

    var readyToSave: Bool {
        !name.isEmpty && (hoursDuration != 0 || minutesDuration != 0)
    }

    // MARK: - Initialization

    private let dataStore: DataStore
    private var activity: Activity?

    init(dataStore: DataStore, activity: Activity? = nil) {
        self.dataStore = dataStore
        self.activity = activity

        if let activity = activity {
            name = activity.name ?? ""
            category = activity.category
            hoursDuration = activity.duration.asHoursAndMinutes.hours
            minutesDuration = activity.duration.asHoursAndMinutes.minutes
            createdAt = activity.createdAt ?? Date()
            notes = activity.notes ?? ""
        }
    }

    // MARK: - Public Methods

    func save() {
        activity = activity ?? Activity(context: dataStore.context)
        activity?.name = name
        activity?.category = category
        activity?.duration = TimeInterval.calculateTotalDurationFrom(hours: hoursDuration, minutes: minutesDuration)
        activity?.createdAt = createdAt
        activity?.notes = notes
        Activity.save(with: dataStore.context)
        donateAddNewActivityIntent()
    }

    // MARK: - Private Methods

    private func donateAddNewActivityIntent() {
        let intent = AddNewActivityIntent()
        intent.name = name
        let totalDuration = TimeInterval.calculateTotalDurationFrom(hours: hoursDuration, minutes: minutesDuration)
        intent.durationInMinutes = NSNumber(value: (totalDuration / TimeInterval.oneHour) * TimeInterval.oneMinute)
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.donate(completion: nil)
    }
}
