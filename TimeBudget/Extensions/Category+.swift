//
//  Category+.swift
//  TimeBudget
//
//  Created by Derrick Showers on 8/11/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import Foundation
import SwiftUI

extension Category {

    var timeSpentDuration: Int {
        return 0
    }

    // MARK: - Mock Data

    static var mockCategory: Category {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let category = Category(context: context)
        category.name = "Category Name"
        category.dailyBudgetDuration = 5
        return category
    }
}
