//
//  Date+.swift
//  Busyless
//
//  Created by Derrick Showers on 1/14/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation

extension Date {
    var prettyTime: String { timeFormatter.string(from: self) }
    var prettyDate: String { dateFormatter.string(from: self) }

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.doesRelativeDateFormatting = true
        formatter.dateStyle = .medium
        return formatter
    }
}
