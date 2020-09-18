//
//  CategoryDetailView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/17/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct CategoryDetailView: View {

    // MARK: - Public Properties

    let category: Category

    // MARK: - Private Properties

    @State private var showingAddNewActivityView = false
    @State private var newDuration = ""

    @Environment(\.presentationMode)
    private var presentationMode

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    private var activities: [Activity] {
        guard let activities = category.activities?.allObjects as? [Activity] else {
            return []
        }

        return activities.filter { activity in
            guard let date = activity.createdAt else {
                return false
            }
            return Calendar.current.isDateInToday(date)
        }
    }

    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Duration (in hours)")
                    TextField("\(Int(category.dailyBudgetDuration / TimeInterval.oneHour))",
                        text: $newDuration)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                }
                .padding(20)
                .background(Color(UIColor.systemGray5))

                if activities.count > 0 {
                    List {
                        ForEach(activities, id: \.self) { (activity: Activity) in
                            HStack {
                                Text(activity.name ?? "")
                                    .font(.body)
                                Spacer()
                                Text(activity.duration.hoursMinutesString)
                                    .font(.caption)
                            }
                        }
                    }
                    .onAppear {
                        UITableView.appearance().separatorStyle = .none
                    }
                } else {
                    Spacer()
                    Text("No logged activities for this category").font(.callout)
                    Spacer()
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton {
                        self.showingAddNewActivityView.toggle()
                    }
                }
            }
        }
        .navigationBarTitle(category.name ?? "Category Detail")
        .navigationBarItems(trailing: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Done")
        }))
        .onDisappear {
            if !self.newDuration.isEmpty {
                let newDuration = TimeInterval(self.newDuration) ?? 0
                self.category.dailyBudgetDuration = newDuration * TimeInterval.oneHour
                Category.save(with: self.managedObjectContext)
            }

        }
        .sheet(isPresented: $showingAddNewActivityView) {
            AddNewActivityView(isPresented: self.$showingAddNewActivityView, preselectedCategory: self.category)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailView(category: Category.mockCategory())
    }
}
