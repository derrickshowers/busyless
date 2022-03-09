//
//  ActivityRow.swift
//  Busyless
//
//  Created by Derrick Showers on 1/15/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import BusylessDataLayer
import Foundation
import SwiftUI

struct ActivityRow: View {
    let activity: Activity
    let isEditing: Bool
    let action: () -> Void

    var shouldShowIndicator: Bool {
        activity.category == nil && !isEditing
    }

    var body: some View {
        Button(action: { action() }, label: {
            HStack {
                if shouldShowIndicator {
                    Divider().frame(width: 5)
                        .background(Color.secondaryColor)
                }

                VStack(alignment: .leading) {
                    Text(activity.name ?? "")
                        .foregroundColor(Color.primary)
                        .font(.subheadline)
                    Text(activity.category?.name ?? "Uncategorized")
                        .font(.caption2)
                        .foregroundColor(Color.gray)
                }
                .padding(.vertical, 10)
                .padding(.leading, shouldShowIndicator ? 10 : 25)

                Spacer()

                VStack(alignment: .trailing) {
                    Text(activity.duration.hoursMinutesString)
                        .foregroundColor(Color.primary)
                        .font(.subheadline)
                    if let time = activity.createdAt?.prettyTime {
                        Text(time)
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 10)
                .padding(.trailing, 20)
            }
        })
    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let activity = Activity.mockActivity(withContext: context)
        let activityRow = ActivityRow(
            activity: activity,
            isEditing: false,
            action: {}
        )
        return Group {
            activityRow
            activityRow
                .background(.black)
                .environment(\.colorScheme, .dark)
        }
        .frame(height: 75)
        .previewLayout(.sizeThatFits)
    }
}
