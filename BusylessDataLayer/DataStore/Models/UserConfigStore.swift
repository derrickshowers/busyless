//
//  UserConfigStore.swift
//  BusylessDataLayer
//
//  Created by Derrick Showers on 12/6/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import CoreData
import Foundation
import os

public class UserConfigStore: NSObject, ObservableObject {
    // MARK: - Constants

    static let awakeHourDefault: Int = 7
    public static let awakeDurationDefault: TimeInterval = 16 * 3600
    public static let defaultAwakeTime = Date.today(withHour: awakeHourDefault)
    public static let defaultSleepTime = Date.today(withHour: awakeHourDefault + Int(awakeDurationDefault / 3600))

    // MARK: - Public Properties

    @Published
    public var awakeTime = defaultAwakeTime {
        didSet {
            guard allUserConfigsController.fetchedObjects?.first?.awakeTime != awakeTime else {
                return
            }
            allUserConfigsController.fetchedObjects?.first?.awakeTime = awakeTime
        }
    }

    @Published
    public var sleepTime = defaultSleepTime {
        didSet {
            guard allUserConfigsController.fetchedObjects?.first?.sleepTime != sleepTime else {
                return
            }
            allUserConfigsController.fetchedObjects?.first?.sleepTime = sleepTime
        }
    }

    // MARK: - Private Properties

    private let allUserConfigsController: NSFetchedResultsController<UserConfig>

    // MARK: - Initializer

    init(managedObjectContext: NSManagedObjectContext) {
        allUserConfigsController = NSFetchedResultsController(
            fetchRequest: UserConfig.allUserConfigsFetchRequest,
            managedObjectContext: managedObjectContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        allUserConfigsController.delegate = self

        do {
            try allUserConfigsController.performFetch()
            createUserConfigIfNecessary(
                from: allUserConfigsController.fetchedObjects,
                managedObjectContext: managedObjectContext
            )
            awakeTime = allUserConfigsController.fetchedObjects?.first?.awakeTime ?? UserConfigStore.defaultAwakeTime
            sleepTime = allUserConfigsController.fetchedObjects?.first?.sleepTime ?? UserConfigStore.defaultSleepTime
        } catch {
            Logger().error("Failed to fetch user configs")
        }
    }

    // MARK: - Private Helpers

    private func createUserConfigIfNecessary(
        from fetchedObjects: [NSFetchRequestResult]?,
        managedObjectContext: NSManagedObjectContext
    ) {
        guard fetchedObjects?.count ?? 0 <= 1 else {
            return
        }

        let initialUserConfig = UserConfig(context: managedObjectContext)
        do {
            try managedObjectContext.save()
        } catch {
            os_log("Issue saving data for entity: %@", String(describing: initialUserConfig))
        }
    }
}

extension UserConfigStore: NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let userConfigs = controller.fetchedObjects as? [UserConfig] else {
            return
        }

        if let awakeTime = userConfigs.first?.awakeTime {
            self.awakeTime = awakeTime
        }

        if let sleepTime = userConfigs.first?.sleepTime {
            self.sleepTime = sleepTime
        }
    }
}

private extension Date {
    static func today(withHour hour: Int) -> Date {
        var components = DateComponents()
        components.hour = hour
        return Calendar.current.date(from: components) ?? Date()
    }
}
