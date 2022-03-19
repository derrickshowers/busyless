//
//  Category.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import CoreData
import UIKit

@objc(BLCategory)
public class BLCategory: NSManagedObject {
    public var timeSpentToday: TimeInterval {
        let activities: Set<Activity>? = self.activities as? Set<Activity>
        let calculatedDuration = activities?.reduce(0) { totalDuration, activity -> TimeInterval in
            if let date = activity.createdAt,
               Calendar.current.isDateInToday(date) {
                return totalDuration + activity.duration
            }
            return totalDuration
        }
        return calculatedDuration ?? 0
    }

    public var timeSpentThisMonth: TimeInterval {
        let activities: Set<Activity>? = self.activities as? Set<Activity>
        let calculatedDuration = activities?.reduce(0) { totalDuration, activity -> TimeInterval in
            if let date = activity.createdAt,
               Calendar.current.component(.month, from: date) == Calendar.current.component(.month, from: Date()) {
                return totalDuration + activity.duration
            }
            return totalDuration
        }
        return calculatedDuration ?? 0
    }
}

// MARK: - Core Data

public extension BLCategory {
    static var allCategoriesFetchRequest: NSFetchRequest<BLCategory> {
        let request: NSFetchRequest<BLCategory> = BLCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \BLCategory.name, ascending: true)]
        return request
    }
}

// MARK: - Mock Data

public extension BLCategory {
    static func mockCategory(withContext context: NSManagedObjectContext? = nil) -> BLCategory {
        let result = PersistenceController(inMemory: true)
        let context = context ?? result.container.viewContext
        let category = BLCategory(context: context)
        category.name = "Category Name"
        category.notes = "category notes"
        category.dailyBudgetDuration = 5
        category.activities = [
            Activity.mockActivity(withContext: context),
            Activity.mockActivity(withContext: context),
            Activity.mockActivity(withContext: context),
        ]
        try? context.save()
        return category
    }

    static func mockCategoryWithPastActivities(withContext context: NSManagedObjectContext? = nil) -> BLCategory {
        let result = PersistenceController(inMemory: true)
        let context = context ?? result.container.viewContext
        let category = BLCategory(context: context)
        category.name = "Category Name"
        category.notes = "category notes"
        category.dailyBudgetDuration = 5
        category.activities = [
            Activity.mockActivityFromYesterday(withContext: context),
            Activity.mockActivityFromYesterday(withContext: context),
            Activity.mockActivityFromYesterday(withContext: context),
        ]
        try? context.save()
        return category
    }
}
