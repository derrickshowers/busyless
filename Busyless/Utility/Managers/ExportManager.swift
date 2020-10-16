//
//  ExportManager.swift
//  Busyless
//
//  Created by Derrick Showers on 9/1/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import UIKit
import CoreData
import BusylessDataLayer
import os

class ExportManager {

    // MARK: - Private Properties

    private let managedObjectContext: NSManagedObjectContext
    private var fetchedActivities: [Activity]?

    private var filePath: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: Date())
        return "\(NSTemporaryDirectory())\(dateString)-busyless-export.csv"
    }

    // MARK: - Lifecycle

    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    // MARK: - Public Methods

    func createActivityExportFile() -> URL {
        fetchData()
        let exportString = createExportString()
        return saveToTemporaryFile(exportString: exportString)
    }

    // MARK: - Private Methods

    private func fetchData() {
        self.fetchedActivities = try? managedObjectContext.fetch(Activity.allActivitiesFetchRequest)
    }

    private func saveToTemporaryFile(exportString: String) -> URL {
        let exportFileURL = URL(fileURLWithPath: filePath)
        FileManager.default.createFile(atPath: filePath, contents: Data(), attributes: nil)

        guard let fileHandle = try? FileHandle(forWritingTo: exportFileURL as URL),
            let csvData = exportString.data(using: String.Encoding.utf8, allowLossyConversion: false) else {
            return exportFileURL
        }

        fileHandle.seekToEndOfFile()
        fileHandle.write(csvData)
        fileHandle.closeFile()

        return exportFileURL
    }

    private func createExportString() -> String {
        guard let activities = fetchedActivities, activities.count > 0 else {
            os_log("Tried to create export, but there are no activities fetched.")
            return ""
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        var export = "Date & Time,Name,Category,Duration(hrs),Notes\n"
        for activity in activities {
            var activityCreatedDate = "Unknown,Unknown"
            if let date = activity.createdAt {
                activityCreatedDate = dateFormatter.string(from: date)
            }
            let activityName = activity.name ?? ""
            let activityCategory = activity.category?.name ?? "Uncategorized"
            let activityDuration = activity.duration / TimeInterval.oneHour
            let activityNotes = activity.notes ?? ""
            export += "\"\(activityCreatedDate)\",\"\(activityName)\",\"\(activityCategory)\",\"\(activityDuration)\",\"\(activityNotes)\"\n"
        }

        os_log("About to export the following CSV: %s", export)

        return export
    }
}
