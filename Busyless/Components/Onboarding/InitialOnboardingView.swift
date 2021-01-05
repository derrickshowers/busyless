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
                          summary: "Busyless is designed to make you feel less busy by motivating you to think about your time differently. It’s not a replacement for your calendar, or your todo list, but a budget of sorts. Instead of money, though, you’ll be able to budget your time in the most meaningful way possible. Let’s get started by discovering how you might use this app. Swipe to the right (or “skip” if this is old news). Note: you can always come back here in settings.",
                          isLogo: true)
    }
}

private struct OnboardingStep2: View {
    var body: some View {
        OnboardingContent(imageName: "Options",
                          headline: "Today View",
                          summary: "You’ll likely end up here first with either some categories you’ve already created or some sample ones – feel free to delete, these are just here to help you get started. These categories allow you to bucket today’s time. Tap a category and choose a desired duration. Then, add a new activity by tapping the plus button at the bottom right of the screen.")
    }
}

private struct OnboardingStep3: View {
    var body: some View {
        OnboardingContent(imageName: "PersonalFinance",
                          headline: "What’s the Point?",
                          summary: "Think of spending your time today as you would money in a bank. You start out with 16 hours (just like having a starting balance of $500) and then plan where you intend to spend it. Sometimes you find you have to spend your time on something unexpected (same as you would have to pay for an unexpected cost). The total amount of available time (or money) stays the same, so you’ll want to move things around and reprioritize. It suddenly becomes clear when you’re puling time from certain buckets you may not want to, and have a better feel for how you’re spending your time.")
    }
}

private struct OnboardingStep4: View {
    var body: some View {
        OnboardingContent(imageName: "TimeManagement",
                          headline: "How Much Time Do I Have?",
                          summary: "The percentage of that time you budget each day is up to you! Let’s revisit the financial budget. Say you start out with $500. You might be the type who budgets absolutely everything. Or, you might decide you’re only going to budget $300 and leave the rest as a buffer. The same applies to your budgeted time. To make it easy, we’ll keep a running percentage at the top of the Today view as you go through and budget time to each category (pro tip: set  awake and sleep time in settings for an accurate percentage). We found 80% is a good starting point, but you’ll figure it out as you go.")
    }
}

private struct OnboardingStep5: View {
    var body: some View {
        OnboardingContent(imageName: "MobileShortcuts",
                          headline: "Entering Activities",
                          summary: "As mentioned previously, adding a new activity is as easy as tapping the plus button on the bottom right. If you’re into iOS shortcuts, there’s an even better option! We’ve added a sample shortcut (in settings) to help you get started. The possibilities are endless when using shortcuts. Create a pomodoro timer that activities Do Not Disturb and logs your activity into Busyless. Or, automatically log a run anytime you start a workout!")
    }
}

private struct OnboardingStep6: View {
    var body: some View {
        OnboardingContent(imageName: "Meditation",
                          headline: "Go Lead a Busyless Life!",
                          summary: "Enjoy the app. Log everything you do. Checkout out the other areas to see a list of all your activities and a monthly view of where your time is going. If this is all too much and you just want to play around, come back to this anytime in settings. Also, reach out to us on Twitter @BusylessApp if you need any advice, have questions, or want to better understand how Busyless can help you!",
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
