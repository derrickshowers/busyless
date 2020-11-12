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
public class Activity: NSManagedObject {
}

// MARK: - Core Data

public extension Activity {

    static var allActivitiesFetchRequest: NSFetchRequest<Activity> {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.createdAt, ascending: false)]
        return request
    }

    static var allActivitiesCurrentMonthFetchRequest: NSFetchRequest<Activity> {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        if let startDate = Date().startOfMonth() as NSDate?, let endDate = Date().endOfMonth() as NSDate? {
            request.predicate = NSPredicate(format: "createdAt >= %@ AND createdAt <= %@", startDate, endDate)
        }
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.createdAt, ascending: false)]
        return request
    }
}

// MARK: - Mock Data {

public extension Activity {

    static func mockActivity(withContext context: NSManagedObjectContext? = nil) -> Activity {
        let result = PersistenceController(inMemory: true)
        let context = context ?? result.container.viewContext
        let activity = Activity(context: context)
        activity.createdAt = Date()
        activity.duration = 1 * 3600
        activity.name = "Test activity"
        activity.notes = "Some notes"
        return activity
    }

    static func mockActivityFromYesterday(withContext context: NSManagedObjectContext? = nil) -> Activity {
        let result = PersistenceController(inMemory: true)
        let context = context ?? result.container.viewContext
        let activity = Activity.mockActivity(withContext: context)
        activity.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return activity
    }
}
