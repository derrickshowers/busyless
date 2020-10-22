//
//  CategoryDetailView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/17/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI
import BusylessDataLayer

struct CategoryDetailView: View {

    // MARK: - Public Properties

    let category: BLCategory

    // MARK: - Private Properties

    @State private var showingAddNewActivityView = false
    @State private var hoursDuration: Int
    @State private var minutesDuration: Int

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

    init(category: BLCategory) {
        self.category = category

        let calculatedDuration = category.dailyBudgetDuration.asHoursAndMinutes
        _hoursDuration = State(initialValue: calculatedDuration.hours)
        _minutesDuration = State(initialValue: calculatedDuration.minutes)
    }

    var body: some View {
        ZStack {
            VStack {
                VStack {
                    HStack {
                        Text("Duration")
                        Spacer()
                        Picker("\(hoursDuration) hours", selection: $hoursDuration, content: {
                            ForEach(0..<6, id: \.self) { hours in
                                Text("\(hours) hours").tag(hours)
                            }
                        }).pickerStyle(MenuPickerStyle())
                        Picker("\(minutesDuration) Minutes", selection: $minutesDuration, content: {
                            Text("0 minutes").tag(0)
                            Text("15 minutes").tag(15)
                            Text("30 minutes").tag(30)
                            Text("45 minutes").tag(45)
                        }).pickerStyle(MenuPickerStyle())
                    }
                    HStack {
                        Spacer()
                        Text("Tap To Change")
                            .font(Font.caption2.lowercaseSmallCaps())
                    }
                }
                .foregroundColor(.white)
                .padding(20)
                .background(Color.mainColor)

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
                        HStack {
                            Text("Total Time Spent Today")
                            Spacer()
                            Text(activities.map({$0.duration}).reduce(0, +).hoursMinutesString)
                        }
                        .font(Font.headline.bold())
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
            self.category.dailyBudgetDuration = TimeInterval.calculateTotalDurationFrom(hours: hoursDuration, minutes: minutesDuration)
            BLCategory.save(with: self.managedObjectContext)

        }
        .sheet(isPresented: $showingAddNewActivityView) {
            AddNewActivityView(isPresented: self.$showingAddNewActivityView, preselectedCategory: self.category)
                .environment(\.managedObjectContext, self.managedObjectContext)
        }
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryDetailView(category: BLCategory.mockCategory())
            CategoryDetailView(category: BLCategory.mockCategory())
                .environment(\.colorScheme, .dark)
        }
    }
}
