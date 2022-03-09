//
//  OnboardingContent.swift
//  Busyless
//
//  Created by Derrick Showers on 12/29/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct OnboardingContent: View {
    // MARK: - Private Properties

    @Environment(\.presentationMode)
    private var presentationMode

    private var isSmallScreen: Bool {
        return UIScreen.main.bounds.height < 700
    }

    // MARK: - Public Properties

    let imageName: String
    let headline: String
    let summary: LocalizedStringKey
    var isLogo = false
    var dismissButtonText: String?

    // MARK: - Lifecycle

    var body: some View {
        VStack {
            if isLogo {
                Image(imageName)
                    .resizable()
                    .frame(
                        width: isSmallScreen ? 75 : 150,
                        height: isSmallScreen ? 75 : 150
                    )
                    .cornerRadius(25)
                    .padding(.bottom, isSmallScreen ? 10 : 30)
            } else {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: isSmallScreen ? 100 : 200)
                    .padding(.bottom, isSmallScreen ? 10 : 30)
            }
            Text(headline)
                .foregroundColor(Color.mainColor)
                .font(isSmallScreen ? .title3 : .title)
                .bold()
            Rectangle()
                .fill(Color.mainColor)
                .frame(maxWidth: 75, maxHeight: 1)
                .padding(.bottom, isSmallScreen ? 8 : 15)
            Text(summary)
                .font(.callout)
            if let buttonText = dismissButtonText {
                Button(buttonText) { presentationMode.wrappedValue.dismiss() }
                    .padding(.top, isSmallScreen ? 10 : 30)
            }
        }
    }
}

struct OnboardingContent_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            OnboardingContent(
                imageName: "LogoWithBackground",
                headline: "Headline",
                summary: "Summary",
                isLogo: true
            )
            OnboardingContent(
                imageName: "WorkTime",
                headline: "Headline",
                summary: "Summary"
            )
        }
    }
}
