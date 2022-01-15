//
//  MainViewModel.swift
//  Busyless
//
//  Created by Derrick Showers on 1/13/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation

class MainViewModel: ObservableObject {
    let logView: LogView

    init(logView: LogView) {
        self.logView = logView
    }
}
