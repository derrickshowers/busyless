//
//  Activity.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import CoreData
import UIKit

@objc(Activity)
public class Activity: NSManagedObject {}

// MARK: - Core Data

public extension Activity {
    static var allActivitiesFetchRequest: NSFetchRequest<Activity> {
        let request: NSFetchRequest<Activity> = Activity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.createdAt, ascending: false)]
        return request
    }

    override func copy() -> Any {
        guard let context = managedObjectContext else {
            return Activity()
        }
        let newActivity = Activity(context: context)
        newActivity.name = name
        newActivity.category = category
        newActivity.duration = duration
        newActivity.createdAt = createdAt
        newActivity.notes = notes
        return newActivity
    }
}

public extension Array where Element: Activity {
    func filter(byMonth month: Int) -> [Element] {
        return filter {
            guard let createdAtDate = $0.createdAt else {
                return false
            }
            return Calendar.current.component(.month, from: createdAtDate) == month
        }
    }

    func filter(byDate date: Date) -> [Element] {
        return filter { activity in
            guard let activityDate = activity.createdAt else {
                return false
            }
            return Calendar.current.isDate(activityDate, inSameDayAs: date)
        }
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
        try? context.save()
        return activity
    }

    static func mockActivityFromYesterday(withContext context: NSManagedObjectContext? = nil) -> Activity {
        let result = PersistenceController(inMemory: true)
        let context = context ?? result.container.viewContext
        let activity = Activity.mockActivity(withContext: context)
        activity.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        try? context.save()
        return activity
    }
}
