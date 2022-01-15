//
//  ActivityRow.swift
//  Busyless
//
//  Created by Derrick Showers on 1/15/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import Foundation
import SwiftUI
import BusylessDataLayer

struct ActivityRow: View {
    let activity: Activity
    let action: () -> Void

    var body: some View {
        Button(action: { action() }, label: {
            HStack {
                if activity.category == nil {
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
                .padding(.leading, activity.category == nil ? 10 : 25)

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
        let activityRow = ActivityRow(activity: Activity.mockActivity(withContext: context), action: { })
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
