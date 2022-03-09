//
//  UserConfig.swift
//  Busyless
//
//  Created by Derrick Showers on 8/26/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import CoreData
import Foundation

@objc(UserConfig)
public class UserConfig: NSManagedObject {}

// MARK: - Core Data

public extension UserConfig {
    static var allUserConfigsFetchRequest: NSFetchRequest<UserConfig> {
        let request: NSFetchRequest<UserConfig> = UserConfig.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserConfig.objectID, ascending: true)]
        return request
    }
}
