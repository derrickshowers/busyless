//
//  Activity.swift
//  TimeBudget
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
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        return request
    }
}

// MARK: - Mock Data {

extension Activity {

    static var mockActivity: Activity {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let activity = Activity(context: context)
        activity.createdAt = Date()
        activity.duration = 1
        activity.name = "Test activity"
        activity.notes = "Some notes"
        return activity
    }

    static var mockActivityFromYesterday: Activity {
        let activity = Activity.mockActivity
        activity.createdAt = Calendar.current.date(byAdding: .day, value: -1, to: Date())
        return activity
    }
}
