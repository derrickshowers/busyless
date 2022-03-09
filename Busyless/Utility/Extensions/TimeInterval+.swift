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
        let formatter = NumberFormatter()
        let number = NSNumber(value: self / TimeInterval.oneHour)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return String(formatter.string(from: number) ?? "")
    }

    var asHoursAndMinutes: (hours: Int, minutes: Int) {
        let durationInHours = self / TimeInterval.oneHour
        var roundedHours = Int(durationInHours)
        let hourPercentageRemaining = durationInHours - Double(roundedHours)
        var minutes = 0
        if hourPercentageRemaining > 0.75 {
            roundedHours += 1
            minutes = 0
        } else if hourPercentageRemaining > 0.5 {
            minutes = 45
        } else if hourPercentageRemaining > 0.25 {
            minutes = 30
        } else if hourPercentageRemaining > 0 {
            minutes = 15
        }
        return (hours: roundedHours, minutes: minutes)
    }

    static func calculateTotalDurationFrom(hours: Int, minutes: Int) -> TimeInterval {
        let totalDuration = TimeInterval(Double(hours) + (Double(minutes) / 60.0))
        return totalDuration * TimeInterval.oneHour
    }
}
