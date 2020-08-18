//
//  NSManagedObject+.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Foundation
import CoreData
import os

extension NSManagedObject {
    static func save(with moc: NSManagedObjectContext) {
        do {
            try moc.save()
        } catch {
            os_log("Issue saving data for entity: %@", String(describing: self))
        }
    }
}
