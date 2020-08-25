//
//  LogView.swift
//  Busyless
//
//  Created by Derrick Showers on 8/16/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct LogView: View {

    // MARK: - Private Properties

    @State private var selection: Set<Activity> = []

    @Environment(\.managedObjectContext)
    private var managedObjectContext

    @FetchRequest(fetchRequest: Activity.allActivitiesFetchRequest)
    private var activities: FetchedResults<Activity>

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }

    // MARK: - Lifecycle

    var body: some View {
        List {
            ForEach(update(activities), id: \.self) { (section: [Activity]) in
                Section(header: Text(self.sectionHeader(forCreationDate: section[0].createdAt))) {
                    ForEach(section, id: \.self) { (activity: Activity) in
                        VStack(alignment: .leading) {
                            Text(activity.name ?? "")
                                .font(.headline)
                            HStack {
                                Text(activity.category?.name ?? "Uncategorized")
                                Text("•")
                                Text(activity.duration.hoursMinutesString)
                            }
                            .font(.caption)
                            .foregroundColor(.gray)
                            NotesView(noteText: activity.notes, isExpanded: self.selection.contains(activity))
                        }
                        .onTapGesture { self.toggleNotes(for: activity) }
                    }
                    .onDelete(perform: self.deleteActivity)
                }
            }
        }
        .onAppear {
            UITableView.appearance().separatorStyle = .none
        }
        .navigationBarTitle("Activity Log")
    }

    // MARK: - Private Methods

    private func toggleNotes(for activity: Activity) {
        if selection.contains(activity) {
            selection.remove(activity)
        } else {
            selection.insert(activity)
        }
    }

    /**
     Groups activities into a 2-dimensional array so it can be split into sections.
     I'm not sure this is the greatest solution as there are multiple SoTs, the original fetched request and what is returned from this. If the two aren't
     sorted in exactly the same way, it will cause weird bugs like deleting by offset. See linked article below for details.
     https://stackoverflow.com/questions/59180698/how-to-properly-group-a-list-fetched-from-coredata-by-date/59182120#59182120

     Note: I think the cleaner way to do this is use a computed property to return this `[[Activity]]`and then use that as the
     single SoT for all (incl. deletion).

     Or better yet, just build a Core Data abstraction layer.
     */
    private func update(_ result: FetchedResults<Activity>) -> [[Activity]] {
        let groupingByDate: [String: [Activity]] = Dictionary(grouping: result) { (activity: Activity) in
            if let date = activity.createdAt {
                return dateFormatter.string(from: date)
            }
            return "unknown"
        }
        return groupingByDate.values.sorted { $0[0].createdAt ?? Date() > $1[0].createdAt ?? Date() }
    }

    private func sectionHeader(forCreationDate date: Date?) -> String {
        if let date = date {
            return dateFormatter.string(from: date)
        }
        return "Unknown Date"
    }
}

// MARK: - Core Data

extension LogView {

    private func deleteActivity(at offsets: IndexSet) {
        offsets.forEach { index in
            let activity = self.activities[index]
            self.managedObjectContext.delete(activity)
        }
        Category.save(with: managedObjectContext)
    }
}

private struct NotesView: View {
    let noteText: String?
    let isExpanded: Bool

    var body: some View {
        VStack {
            if isExpanded {
                Spacer()
                Text(noteText ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
                Spacer()
            }
        }
        .contentShape(Rectangle())
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        // swiftlint:disable:next force_cast
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        return LogView().environment(\.managedObjectContext, context)
    }
}
