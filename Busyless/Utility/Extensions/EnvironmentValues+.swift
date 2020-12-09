//
//  EnvironmentValues+.swift
//  Busyless
//
//  Created by Derrick Showers on 12/6/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct DateStoreKey: EnvironmentKey {
    static var defaultValue: ObservedObject<DataStore>?
}

extension EnvironmentValues {
    var dataStore: ObservedObject<DataStore>? {
        get { self[DateStoreKey.self] }
        set { self[DateStoreKey.self] = newValue }
    }
}
