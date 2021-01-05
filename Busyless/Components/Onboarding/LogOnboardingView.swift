//
//  LogOnboardingView.swift
//  Busyless
//
//  Created by Derrick Showers on 12/27/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct LogOnboardingView: View {

    // MARK: - Lifecycle

    var body: some View {
        OnboardingShell {
            OnboardingStep1().padding(.horizontal, 25)
            OnboardingStep2().padding(.horizontal, 25)
        }.colorScheme(.light)
    }
}

private struct OnboardingStep1: View {
    var body: some View {
        OnboardingContent(imageName: "List",
                          headline: "Welcome to Activity Log",
                          summary: "Here you can view all of the activities you entered, as well as when it was entered and its duration. If you entered an activity via a shortcut, or forgot to chose a category, you’ll see a banner at the top letting you know you have uncategorized activities. Tap the banner to filter to only these activities.")
    }
}

private struct OnboardingStep2: View {
    var body: some View {
        OnboardingContent(imageName: "Download",
                          headline: "Save Your Data",
                          summary: "All of your data is securely backed up to iCloud, so it will be available if you reinstall the app or use on a different device. However, you might still decide you want to backup your data or even use it for something else. In settings, choose “Export Data to CSV” and then save somewhere like Google Drive or iCloud Files.",
                          dismissButtonText: "Sounds great!")
    }
}
