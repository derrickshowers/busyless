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

    // MARK: - Constants

    static let durationSliderHeight: CGFloat = 325

    // MARK: - Public Properties

    let category: BLCategory
    let overviewType: OverviewType

    // MARK: - Private Properties

    @State private var showingAddNewActivityView = false
    @State private var duration: TimeInterval
    @State private var contextCategory: ContextCategory?

    @Environment(\.presentationMode)
    private var presentationMode

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    private var activities: [Activity] {
        guard let activities = category.activities?.allObjects as? [Activity] else {
            return []
        }

        if overviewType == .month {
            return activities.filter(byMonth: Calendar.current.component(.month, from: Date()))
        }

        return activities.filter(byDate: Date())
    }

    private var timeLeftInCurrentCategory: TimeInterval {
        return duration - activities.map({$0.duration}).reduce(0, +)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }

    // MARK: - Lifecycle

    init(category: BLCategory, overviewType: OverviewType) {
        self.category = category
        self.overviewType = overviewType
        _duration = State(initialValue: category.dailyBudgetDuration)
        _contextCategory = State(initialValue: category.contextCategory)
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    if overviewType == .day {
                        HStack {
                            DurationSlider(duration: $duration, maxDuration: 8 * TimeInterval.oneHour)
                                .frame(maxWidth: CategoryDetailView.durationSliderHeight,
                                       minHeight: CategoryDetailView.durationSliderHeight,
                                       maxHeight: CategoryDetailView.durationSliderHeight)
                                .padding(.vertical, 10)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.customWhite)
                    }

                    VStack(spacing: 15) {
                        HStack {
                            Text("Time spent")
                            Spacer()
                            if overviewType == .day {
                                Text(category.timeSpentToday.hoursMinutesString).bold()
                            } else {
                                Text(category.timeSpentThisMonth.hoursMinutesString).bold()
                            }

                        }
                        if overviewType == .day {
                            Divider()
                            HStack {
                                Text("Time left in \(category.name?.lowercased() ?? "category")")
                                Spacer()
                                Text(abs(timeLeftInCurrentCategory).hoursMinutesString)
                                    .foregroundColor(timeLeftInCurrentCategory >= 0 ? Color(UIColor.label) : Color.red)
                                    .bold()
                            }
                        }
                        Divider()
                        HStack {
                            NavigationLink(destination: ContextCategorySelection(selectedContextCategory: $contextCategory)) {
                                Text("Context Category")
                                    .foregroundColor(Color(UIColor.label))
                                Spacer()
                                Text("\(contextCategory?.name ?? "Tap to Assign")")
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(15)
                    .background(Color.customWhite)

                    HStack {
                        Text("Logged Activities")
                            .font(Font.headline.smallCaps())
                        Spacer()
                    }.padding(15)

                    HStack {
                        if activities.count > 0 {
                            VStack(spacing: 15) {
                                ForEach(activities, id: \.self) { (activity: Activity) in
                                    HStack {
                                        if overviewType == .month, let date = activity.createdAt {
                                            Text(dateFormatter.string(from: date))
                                                .font(.caption)
                                        }
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
                    }.padding(.bottom, 35)

                    VStack(alignment: .leading, spacing: 15) {
                        Divider()
                        Button(action: {
                            category.trackMonthly.toggle()
                        }, label: {
                            if category.trackMonthly {
                                Image(systemName: "eye.slash.fill")
                                Text("Hide Category on Month View")
                            } else {
                                Image(systemName: "eye.fill")
                                Text("Show Category on Month View")
                            }
                        })
                        .foregroundColor(Color(UIColor.systemGray))
                        Divider()
                    }.padding(.leading, 15)
                    .padding(.bottom, 150)
                }
            }
            .background(Color(UIColor.systemGray6))
            .edgesIgnoringSafeArea(.bottom)

            VStack {
                Spacer()
                HStack {
                    Spacer()
                    AddButton {
                        showingAddNewActivityView.toggle()
                    }
                }
            }
        }
        .navigationBarTitle(category.name ?? "Category Detail")
        .onDisappear {
            category.dailyBudgetDuration = duration
            category.contextCategory = contextCategory
            BLCategory.save(with: managedObjectContext)

        }
        .sheet(isPresented: $showingAddNewActivityView) {
            AddNewActivityView(preselectedCategory: category) {
                showingAddNewActivityView = false
            }.environment(\.managedObjectContext, managedObjectContext)
        }
    }
}

extension CategoryDetailView {
    enum OverviewType {
        case day
        case month
    }
}

struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CategoryDetailView(category: BLCategory.mockCategory(), overviewType: .day)
            CategoryDetailView(category: BLCategory.mockCategory(), overviewType: .day)
                .environment(\.colorScheme, .dark)
        }
        Group {
            CategoryDetailView(category: BLCategory.mockCategory(), overviewType: .month)
            CategoryDetailView(category: BLCategory.mockCategory(), overviewType: .month)
                .environment(\.colorScheme, .dark)
        }
    }
}
