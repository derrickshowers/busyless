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
                          summary: "LogOnboardingStep1Summary")
    }
}

private struct OnboardingStep2: View {
    var body: some View {
        OnboardingContent(imageName: "Download",
                          headline: "Save Your Data",
                          summary: "LogOnboardingStep2LogOnboardingStep1SummarySummary",
                          dismissButtonText: "Sounds great!")
    }
}
