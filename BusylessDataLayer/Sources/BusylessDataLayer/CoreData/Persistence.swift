//
//  Persistence.swift
//  Busyless
//
//  Created by Derrick Showers on 9/18/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import CoreData

public class GroupedPersistentCloudKitContainer: NSPersistentCloudKitContainer {
    enum URLStrings: String {
        case group = "group.com.derrickshowers.busyless"
    }

    override public class func defaultDirectoryURL() -> URL {
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: URLStrings.group.rawValue)

        if !FileManager.default.fileExists(atPath: url!.path) {
            try? FileManager.default.createDirectory(at: url!, withIntermediateDirectories: true, attributes: nil)
        }
        return url!
    }
}

public struct PersistenceController {
    public static let shared = PersistenceController()

    public static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0 ..< 10 {
            _ = Activity.mockActivity(withContext: viewContext)
        }
        for _ in 0 ..< 10 {
            _ = BLCategory.mockCategory(withContext: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    public let container: GroupedPersistentCloudKitContainer

    public init(inMemory: Bool = false) {
        if let modelURL = Bundle.module.url(forResource: "Busyless", withExtension: "momd"),
           let model = NSManagedObjectModel(contentsOf: modelURL) {
            container = GroupedPersistentCloudKitContainer(name: "Busyless", managedObjectModel: model)
        } else {
            // If we get here, we likely won't be able to load the persistent container.
            // Setting it anyway to avoid making container an optional.
            assertionFailure("Could not load persistent container")
            container = GroupedPersistentCloudKitContainer(name: "Busyless")
        }

        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }

        container.viewContext.automaticallyMergesChangesFromParent = true
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
