//
//  CategoryStore.swift
//  BusylessDataLayer
//
//  Created by Derrick Showers on 12/5/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Foundation
import CoreData
import os

public class CategoryStore: NSObject, ObservableObject {

    // MARK: - Public Properties

    @Published
    public private(set) var allCategories: [BLCategory] = []

    @Published
    public private(set) var allCategoriesSortedByTimeSpentThisMonth: [BLCategory] = []

    @Published
    public private(set) var allContextCategories: [ContextCategory] = []

    // MARK: - Private Properties

    private let allCategoriesController: NSFetchedResultsController<BLCategory>
    private let allContextCategoriesController: NSFetchedResultsController<ContextCategory>

    // MARK: - Initializer

    public init(managedObjectContext: NSManagedObjectContext) {
        allCategoriesController = NSFetchedResultsController(fetchRequest: BLCategory.allCategoriesFetchRequest,
                                                             managedObjectContext: managedObjectContext,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)
        allContextCategoriesController = NSFetchedResultsController(fetchRequest: ContextCategory.allContextCategoriesFetchRequest,
                                                                    managedObjectContext: managedObjectContext,
                                                                    sectionNameKeyPath: nil,
                                                                    cacheName: nil)

        super.init()

        allCategoriesController.delegate = self
        allContextCategoriesController.delegate = self

        do {
            try allCategoriesController.performFetch()
            try allContextCategoriesController.performFetch()
            allCategories = allCategoriesController.fetchedObjects ?? []
            allCategoriesSortedByTimeSpentThisMonth = allCategories.sorted { $0.timeSpentThisMonth > $1.timeSpentThisMonth }
            allContextCategories = allContextCategoriesController.fetchedObjects ?? []
        } catch {
            Logger().error("Failed to fetch categories or context categories")
        }
    }
}

extension CategoryStore: NSFetchedResultsControllerDelegate {

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        if controller.fetchRequest.entity?.managedObjectClassName == String(describing: BLCategory.self),
           let categories = controller.fetchedObjects as? [BLCategory] {
            allCategories = categories
            allCategoriesSortedByTimeSpentThisMonth = categories.sorted { $0.timeSpentThisMonth > $1.timeSpentThisMonth }
        }
        if controller.fetchRequest.entity?.managedObjectClassName == String(describing: ContextCategory.self),
           let contextCategories = controller.fetchedObjects as? [ContextCategory] {
            allContextCategories = contextCategories
        }
    }

}
