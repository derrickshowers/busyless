//
//  Date+.swift
//  Busyless
//
//  Created by Derrick Showers on 11/11/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Foundation

extension Date {
    func startOfMonth() -> Date? {
        let dateComponents = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: dateComponents)
    }

    func endOfMonth() -> Date? {
        var dateComponents = DateComponents()
        dateComponents.month = 1

        guard let nextMonth = Calendar.current.date(byAdding: dateComponents, to: self) else {
            return nil
        }

        let nextMonthDateComponents = Calendar.current.dateComponents([.year, .month], from: nextMonth)
        return Calendar.current.date(from: nextMonthDateComponents)?.addingTimeInterval(-1)
    }
}
