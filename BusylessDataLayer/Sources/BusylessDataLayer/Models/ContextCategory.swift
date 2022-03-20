//
//  ContextCategory.swift
//  BusylessDataLayer
//
//  Created by Derrick Showers on 12/21/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import CoreData
import Foundation

@objc(ContextCategory)
public class ContextCategory: NSManagedObject {
    public var timeBudgeted: TimeInterval {
        return categories?.allObjects.reduce(0) { $0 + (($1 as? BLCategory)?.dailyBudgetDuration ?? 0) } ?? 0
    }
}

// MARK: - Core Data

public extension ContextCategory {
    static var allContextCategoriesFetchRequest: NSFetchRequest<ContextCategory> {
        let request: NSFetchRequest<ContextCategory> = ContextCategory.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ContextCategory.name, ascending: true)]
        return request
    }
}

// MARK: - Mock Data

public extension ContextCategory {
    static func mockContextCategory(withContext context: NSManagedObjectContext? = nil) -> ContextCategory {
        let result = PersistenceController(inMemory: true)
        let context = context ?? result.container.viewContext
        let category = ContextCategory(context: context)
        category.name = "Context Category Name"
        category.categories = [
            BLCategory.mockCategory(withContext: context),
            BLCategory.mockCategory(withContext: context),
            BLCategory.mockCategory(withContext: context),
        ]
        try? context.save()
        return category
    }
}
