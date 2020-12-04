//
//  DurationSlider.swift
//  Busyless
//
//  Created by Derrick Showers on 10/26/20.
//  Copyright © 2020 Derrick Showers. All rights reserved.
//

import SwiftUI

struct DurationSlider: View {

    // MARK: - Constants

    private static let knobDiameter: CGFloat = 35

    // MARK: - Public Properties

    @Binding var duration: TimeInterval
    let maxDuration: TimeInterval

    // MARK: - Private Properties

    private var angle: CGFloat {
        let fixedAngle = (duration / maxDuration) * (.pi * 2.0)
        return CGFloat(fixedAngle * 180 / .pi)
    }

    // MARK: - Lifecycle

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .fill(Color.mainColor)
                    .frame(width: geometry.size.width, height: geometry.size.width)

                Circle()
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
                    .frame(width: geometry.size.width, height: geometry.size.width)

                Circle()
                    .trim(from: 0.0, to: CGFloat(duration / maxDuration))
                    .stroke(Color.accentGreen, lineWidth: 4)
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    .rotationEffect(.degrees(-90))

                Knob(angle: angle,
                     radius: DurationSlider.knobDiameter / 2,
                     geometry: geometry,
                     containerRadius: geometry.size.width / 2,
                     onChange: change)

                VStack {
                    Text(duration.hoursMinutesString)
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 15)
                    HStack {
                        VStack {
                            Text("hours")
                            Stepper("Hours", onIncrement: {
                                updateDuration(to: duration + TimeInterval.oneHour)
                            }, onDecrement: {
                                updateDuration(to: duration - TimeInterval.oneHour)
                            }).labelsHidden().fixedSize()
                        }
                        VStack {
                            Text("minutes")
                            Stepper("Minutes", onIncrement: {
                                updateDuration(to: duration + TimeInterval.oneHour / 4)
                            }, onDecrement: {
                                updateDuration(to: duration - TimeInterval.oneHour / 4)
                            }).labelsHidden().fixedSize()
                        }
                    }
                    .foregroundColor(Color.white.opacity(0.55))
                }
            }
        }.padding(30)
    }

    // MARK: - Private Methods

    private func change(location: CGPoint) {
        // Create vector from location point
        let vector = CGVector(dx: location.x, dy: location.y)

        // Get angle in radian need to subtract the knob radius and padding
        let knobRadius = DurationSlider.knobDiameter / 2
        let angle = atan2(vector.dy - (knobRadius + 10), vector.dx - (knobRadius + 10)) + .pi / 2.0

        // Convert angle range from (-pi to pi) to (0 to 2pi)
        let fixedAngle = angle < 0.0 ? angle + 2.0 * .pi : angle

        // Convert angle value to duration
        let duration = TimeInterval(fixedAngle / (2.0 * .pi)) * maxDuration
        let roundedDuration = round(duration: duration, toNearest: 0.25)

        // Make sure we don't adjust duration more than an hour
        // (prevents going from min to max when going counterclockwise)
        guard self.duration - roundedDuration < TimeInterval.oneHour,
              roundedDuration - self.duration < TimeInterval.oneHour else {
            return
        }

        updateDuration(to: roundedDuration)
    }

    private func updateDuration(to duration: TimeInterval) {
        guard duration <= maxDuration && duration >= 0 else {
            return
        }
        self.duration = duration
    }

    /**
     Returns a duration rounded to the nearest passed in value.
     Ex: 0.25 passed in for nearest would round duration to 15 minute intervals.
     */
    private func round(duration: TimeInterval, toNearest nearest: Double) -> TimeInterval {
        let durationInHours = duration / TimeInterval.oneHour
        let num = 1 / nearest
        let numberToRound = durationInHours * num
        return (numberToRound.rounded() / num) * TimeInterval.oneHour
    }
}

struct Knob: View {
    let angle: CGFloat
    let radius: CGFloat
    let geometry: GeometryProxy
    let containerRadius: CGFloat
    let onChange: (_ location: CGPoint) -> Void

    var body: some View {
        Circle()
            .fill(Color.accentGreen)
            .frame(width: radius * 2, height: radius * 2)
            .padding(10)
            .offset(y: -containerRadius)
            .rotationEffect(Angle.degrees(Double(angle)))
            .shadow(color: Color.black.opacity(0.25), radius: 1, x: 0, y: 0)
            .gesture(DragGesture(minimumDistance: 0.0).onChanged({ value in
                self.onChange(value.location)
            }))
    }
}

#if DEBUG
struct DurationSlider_Previews: PreviewProvider {
     static var previews: some View {
         StatefulPreviewWrapper(0) {
             DurationSlider(duration: $0, maxDuration: TimeInterval.oneHour * 10).frame(maxWidth: 350)
         }
     }
 }
#endif
