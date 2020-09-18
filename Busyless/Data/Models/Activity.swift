//
//  Activity.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import UIKit
import CoreData

@objc(Activity)
class Activity: NSManagedObject {
}

// MARK: - Core Data

extension Activity {

    static var allActivitiesFetchRequest: NSFetchRequest<Activity> {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.createdAt, ascending: false)]
        return request
    }
}

// MARK: - Mock Data {

extension Activity {

    static func mockActivity(withContext context: NSManagedObjectContext? = nil) -> Activity {
        let result = PersistenceController(inMemory: true)
        let activity = Activity(context: context ?? result.container.viewContext)
        activity.createdAt = Date()
        activity.duration = TimeInterval.oneHour
        activity.name = "Test activity"
        activity.notes = "Some notes"
        return activity
    }

    static var mockActivityFromYesterday: Activity {
        let activity = Activity.mockActivity()
        activity.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return activity
    }
}
