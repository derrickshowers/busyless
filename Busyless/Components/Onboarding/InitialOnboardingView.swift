//
//  InitialOnboardingView.swift
//  Busyless
//
//  Created by Derrick Showers on 12/27/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct InitialOnboardingView: View {

    // MARK: - Lifecycle

    var body: some View {
        OnboardingShell {
            OnboardingStep1().padding(.horizontal, 25)
            OnboardingStep2().padding(.horizontal, 25)
            OnboardingStep3().padding(.horizontal, 25)
            OnboardingStep4().padding(.horizontal, 25)
            OnboardingStep5().padding(.horizontal, 25)
            OnboardingStep6().padding(.horizontal, 25)
        }.colorScheme(.light)
    }
}

private struct OnboardingStep1: View {
    var body: some View {
        OnboardingContent(imageName: "LogoWithBackground",
                          headline: "Welcome To Busyless!",
                          summary: "InitialOnboardingStep1Summary",
                          isLogo: true)
    }
}

private struct OnboardingStep2: View {
    var body: some View {
        OnboardingContent(imageName: "Options",
                          headline: "Today View",
                          summary: "InitialOnboardingStep2Summary")
    }
}

private struct OnboardingStep3: View {
    var body: some View {
        OnboardingContent(imageName: "PersonalFinance",
                          headline: "What’s the Point?",
                          summary: "InitialOnboardingStep3Summary")
    }
}

private struct OnboardingStep4: View {
    var body: some View {
        OnboardingContent(imageName: "TimeManagement",
                          headline: "How Much Time Do I Have?",
                          summary: "InitialOnboardingStep4Summary")
    }
}

private struct OnboardingStep5: View {
    var body: some View {
        OnboardingContent(imageName: "MobileShortcuts",
                          headline: "Entering Activities",
                          summary: "InitialOnboardingStep5Summary")
    }
}

private struct OnboardingStep6: View {
    var body: some View {
        OnboardingContent(imageName: "Meditation",
                          headline: "Go Lead a Busyless Life!",
                          summary: "InitialOnboardingStep6Summary",
                          dismissButtonText: "I’m ready!")
    }
}

// MARK: - Preview

struct InitialOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        return Group {
            InitialOnboardingView()
            InitialOnboardingView().environment(\.colorScheme, .dark)
        }
    }
}
