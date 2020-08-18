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
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        return request
    }
}

// MARK: - Mock Data

extension Category {

    static var mockCategory: Category {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let category = Category(context: context)
        category.name = "Category Name"
        category.dailyBudgetDuration = 5
        category.activities = [Activity.mockActivity, Activity.mockActivity, Activity.mockActivity]
        return category
    }

    static var mockCategoryWithPastActivities: Category {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let category = Category(context: context)
        category.name = "Category Name"
        category.dailyBudgetDuration = 5
        category.activities = [Activity.mockActivityFromYesterday, Activity.mockActivityFromYesterday, Activity.mockActivityFromYesterday]
        return category
    }
}
