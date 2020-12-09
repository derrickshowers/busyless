//
//  StatsView.swift
//  Busyless
//
//  Created by Derrick Showers on 11/2/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct StatsView: View {

    // MARK: - Private Properties

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @Environment(\.dataStore)
    private var dataStore

    private var activities: [Activity] {
        return dataStore?.wrappedValue.activityStore.allActivitiesForCurrentMonth ?? []
    }

    private var categoriesAndDurations: [(categoryName: String, duration: TimeInterval)] {
        var dictionary: [String: TimeInterval] = [:]
        activities.forEach { (activity) in
            let categoryName = activity.category?.name ?? "Uncategorized"
            let currentTotalDuration = dictionary[categoryName] ?? 0
            dictionary[categoryName] = currentTotalDuration + activity.duration
        }
        return dictionary.map { $0 }.sorted { $0.duration > $1.duration }
    }

    private var currentMonth: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM YYYY"
        return dateFormatter.string(from: Date())
    }

    // MARK: - Lifecycle

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text(currentMonth)
                    .font(.title)
                Text("Duration by Category")
                    .font(.caption)
                VStack {
                    ForEach(self.categoriesAndDurations, id: \.categoryName) { (categoryAndDuration: (categoryName: String, duration: TimeInterval)) in
                        HStack {
                            Text(categoryAndDuration.categoryName)
                            Spacer()
                            Text(categoryAndDuration.duration.hoursMinutesString).bold()
                        }
                        if let lastItem = self.categoriesAndDurations.last, categoryAndDuration != lastItem {
                            Divider()
                        }
                    }
                }
                .padding(.horizontal, 25)
                .padding(.vertical, 10)
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .background(Color.customWhite)
        }
        .background(Color(UIColor.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarTitle("Stats")
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return StatsView().environment(\.managedObjectContext, context)
    }
}
