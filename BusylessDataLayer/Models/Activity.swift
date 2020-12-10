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
}

extension Array where Element: Activity {

    public func filter(byMonth month: Int) -> [Element] {
        return self.filter({
            guard let createdAtDate = $0.createdAt else {
                return false
            }
            return Calendar.current.component(.month, from: createdAtDate) == month
        })
    }

    public func filter(byDate date: Date) -> [Element] {
        return self.filter { activity in
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
