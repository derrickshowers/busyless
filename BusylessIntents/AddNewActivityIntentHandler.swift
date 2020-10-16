//
//  AddNewActivityIntentHandler.swift
//  BusylessIntents
//
//  Created by Derrick Showers on 10/7/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Intents
import BusylessDataLayer
import os

class AddNewActivityIntentHandler: NSObject, AddNewActivityIntentHandling {
    let persistenceController = PersistenceController.shared

    func resolveName(for intent: AddNewActivityIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        completion(INStringResolutionResult.success(with: intent.name ?? "Unknown Activity"))
    }

    func resolveDurationInMinutes(for intent: AddNewActivityIntent, with completion: @escaping (AddNewActivityDurationInMinutesResolutionResult) -> Void) {
        completion(AddNewActivityDurationInMinutesResolutionResult.success(with: intent.durationInMinutes?.intValue ?? 0))
    }

    func confirm(intent: AddNewActivityIntent, completion: @escaping (AddNewActivityIntentResponse) -> Void) {
        completion(AddNewActivityIntentResponse(code: .ready, userActivity: nil))
    }

    func handle(intent: AddNewActivityIntent, completion: @escaping (AddNewActivityIntentResponse) -> Void) {
        let name = intent.name ?? "An activity"
        let durationInMinutes = intent.durationInMinutes?.intValue ?? 0
        saveNewActivity(withName: name, durationInMinutes: durationInMinutes)
        completion(AddNewActivityIntentResponse.success(name: name, durationInMinutes: NSNumber(value: durationInMinutes)))
    }
}

// MARK: - Core Data

extension AddNewActivityIntentHandler {

    private func saveNewActivity(withName name: String, durationInMinutes: Int) {
        let moc = persistenceController.container.viewContext
        let activity = Activity(context: moc)
        activity.name = name
        activity.duration = (Double(durationInMinutes) / 60) * 3600
        activity.createdAt = Date()
        do {
            try moc.save()
        } catch {
            os_log("Issue saving data from extension for entity: %@", String(describing: self))
        }
    }
}
