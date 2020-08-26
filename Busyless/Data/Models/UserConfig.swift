//
//  UserConfig.swift
//  Busyless
//
//  Created by Derrick Showers on 8/26/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Foundation
import CoreData

@objc(UserConfig)
class UserConfig: NSManagedObject {
}

// MARK: - Core Data

extension UserConfig {

    static var allUserConfigsFetchRequest: NSFetchRequest<UserConfig> {
        let request: NSFetchRequest<UserConfig> = UserConfig.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \UserConfig.objectID, ascending: true)]
        return request
    }
}
