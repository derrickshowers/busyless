//
//  Category.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import UIKit
import CoreData

@objc(Category)
class Category: NSManagedObject {

    var timeSpentDuration: TimeInterval {
        let activities: Set<Activity>? = self.activities as? Set<Activity>
        let calculatedDuration = activities?.reduce(0) { (totalDuration, activity) -> TimeInterval in
            if let date = activity.createdAt,
                Calendar.current.isDateInToday(date) {
                return totalDuration + activity.duration
            }
            return totalDuration
        }
        return calculatedDuration ?? 0
    }
}

// MARK: - Core Data

extension Category {

    static var allCategoriesFetchRequest: NSFetchRequest<Category> {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
        return request
    }
}

// MARK: - Mock Data

extension Category {

    static func mockCategory(withContext context: NSManagedObjectContext? = nil) -> Category {
        let result = PersistenceController(inMemory: true)
        let context = context ?? result.container.viewContext
        let category = Category(context: context)
        category.name = "Category Name"
        category.dailyBudgetDuration = 5
        category.activities = [Activity.mockActivity(withContext: context),
                               Activity.mockActivity(withContext: context),
                               Activity.mockActivity(withContext: context)]
        return category
    }

    static func mockCategoryWithPastActivities(withContext context: NSManagedObjectContext? = nil) -> Category {
        let result = PersistenceController(inMemory: true)
        let context = context ?? result.container.viewContext
        let category = Category(context: context)
        category.name = "Category Name"
        category.dailyBudgetDuration = 5
        category.activities = [Activity.mockActivityFromYesterday(withContext: context),
                               Activity.mockActivityFromYesterday(withContext: context),
                               Activity.mockActivityFromYesterday(withContext: context)]
        return category
    }
}
