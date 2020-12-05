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

    // MARK: - Private Properties

    private let allCategoriesController: NSFetchedResultsController<BLCategory>

    // MARK: - Initializer

    public init(managedObjectContext: NSManagedObjectContext) {
        allCategoriesController = NSFetchedResultsController(fetchRequest: BLCategory.allCategoriesFetchRequest,
                                                             managedObjectContext: managedObjectContext,
                                                             sectionNameKeyPath: nil,
                                                             cacheName: nil)

        super.init()

        allCategoriesController.delegate = self

        do {
            try allCategoriesController.performFetch()
            allCategories = allCategoriesController.fetchedObjects ?? []
        } catch {
            Logger().error("Failed to fetch categories")
        }
    }
}

extension CategoryStore: NSFetchedResultsControllerDelegate {

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let categories = controller.fetchedObjects as? [BLCategory] else {
            return
        }
        allCategories = categories
    }

}
