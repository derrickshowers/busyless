//
//  TimeInterval+.swift
//  Busyless
//
//  Created by Derrick Showers on 8/17/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Foundation

extension TimeInterval {

    static let oneHour: TimeInterval = 3600
    static let oneMinute: TimeInterval = 60

    var hoursMinutesString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(self)) ?? "0"
    }

    var hoursString: String {
        return String(Int(self / TimeInterval.oneHour))
    }
}
