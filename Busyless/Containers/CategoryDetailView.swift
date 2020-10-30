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
    @State private var duration: TimeInterval

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

    private var timeLeftInCurrentCategory: TimeInterval {
        return duration - activities.map({$0.duration}).reduce(0, +)
    }

    init(category: BLCategory) {
        self.category = category
        _duration = State(initialValue: category.dailyBudgetDuration)

        UIScrollView.appearance().bounces = false
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        DurationSlider(duration: $duration, maxDuration: 6 * TimeInterval.oneHour)
                            .frame(maxWidth: 300, minHeight: 300, maxHeight: 300)
                            .padding(.vertical, 20)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.customWhite)

                    VStack(spacing: 15) {
                        HStack {
                            Text("Time spent today")
                            Spacer()
                            Text(category.timeSpentDuration.hoursMinutesString).bold()
                        }
                        Divider()
                        HStack {
                            Text("Time available to budget")
                            Spacer()
                            Text("Unknown").bold()
                        }
                        Divider()
                        HStack {
                            Text("Time left in \(category.name?.lowercased() ?? "category")")
                            Spacer()
                            Text(abs(timeLeftInCurrentCategory).hoursMinutesString)
                                .foregroundColor(timeLeftInCurrentCategory >= 0 ? Color(UIColor.label) : Color.red)
                                .bold()
                        }
                    }
                    .padding(15)
                    .background(Color.customWhite)

                    HStack {
                        Text("Today's Logged Activities")
                            .font(Font.headline.smallCaps())
                        Spacer()
                    }.padding(15)

                    HStack {
                        if activities.count > 0 {
                            VStack(spacing: 15) {
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
                            .padding(.horizontal, 15)
                        } else {
                            VStack {
                                Text("No logged activities for this category")
                                    .font(.caption)
                                    .foregroundColor(Color(UIColor.placeholderText))
                            }
                            .padding(.horizontal, 15)
                        }
                    }
                }
            }
            .background(Color(UIColor.systemGray6))
            .edgesIgnoringSafeArea(.bottom)

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
        .onDisappear {
            self.category.dailyBudgetDuration = duration
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
