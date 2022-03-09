//
//  ActivityStore.swift
//  BusylessDataLayer
//
//  Created by Derrick Showers on 12/6/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import CoreData
import Foundation
import os

public class ActivityStore: NSObject, ObservableObject {
    // MARK: - Public Properties

    @Published
    public private(set) var allActivities: [Activity] = []

    @Published
    public private(set) var allActivitiesGroupedByDate: [[Activity]] = []

    // MARK: - Private Properties

    private let allActivitiesController: NSFetchedResultsController<Activity>

    // MARK: - Initializer

    init(managedObjectContext: NSManagedObjectContext) {
        allActivitiesController = NSFetchedResultsController(
            fetchRequest: Activity.allActivitiesFetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()
        allActivitiesController.delegate = self
        fetch()
    }

    // MARK: - Public API

    public func deleteAllActivities() {
        let moc = allActivitiesController.managedObjectContext
        allActivities.forEach { activity in
            moc.delete(activity)
        }
        try? moc.save()
    }

    public func fetch() {
        do {
            try allActivitiesController.performFetch()
            allActivities = allActivitiesController.fetchedObjects ?? []
            allActivitiesGroupedByDate = ActivityStore
                .activitiesGroupedByDate(allActivitiesController.fetchedObjects ?? [])
        } catch {
            Logger().error("Failed to fetch activities")
        }
    }

    // MARK: - Private Helpers

    private static func activitiesGroupedByDate(_ activities: [Activity]) -> [[Activity]] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full

        let groupingByDate: [String: [Activity]] = Dictionary(grouping: activities) { (activity: Activity) in
            if let date = activity.createdAt {
                return dateFormatter.string(from: date)
            }
            return "unknown"
        }
        return groupingByDate.values.sorted { $0[0].createdAt ?? Date() > $1[0].createdAt ?? Date() }
    }
}

extension ActivityStore: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let activities = controller.fetchedObjects as? [Activity] else {
            return
        }
        allActivities = activities
        allActivitiesGroupedByDate = ActivityStore.activitiesGroupedByDate(activities)
    }
}
