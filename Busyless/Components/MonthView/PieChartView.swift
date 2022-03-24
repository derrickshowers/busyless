//
//  PieChartView.swift
//  Busyless
//
//  Created by Derrick Showers on 3/21/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import SwiftUI

struct PieChartView: View {
    let slices: [(value: Double, color: Color, name: String)]

    @State private var activeSlice: PieSliceData?

    private var slicesData: [PieSliceData] {
        let values = slices.map { $0.value }
        let sum = values.reduce(0, +)
        var endDegrees: Double = 0
        var tempSlices: [PieSliceData] = []

        slices.forEach { value, color, _ in
            let degrees = value * 360 / sum
            tempSlices.append(PieSliceData(
                startAngle: Angle(degrees: endDegrees),
                endAngle: Angle(degrees: endDegrees + degrees),
                color: color
            ))
            endDegrees += degrees
        }

        return tempSlices
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(slicesData, id: \.self) { sliceData in
                    PieSliceView(pieSliceData: sliceData)
                }

                Circle()
                    .fill(.white)
                    .frame(width: geometry.size.width * 0.6, height: geometry.size.width * 0.6)
            }
        }
    }
}

struct PieChartRows: View {
    let slices: [(value: Double, color: Color, name: String)]

    var body: some View {
        VStack {
            ForEach(slices, id: \.name) { value, color, name in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(color)
                        .frame(width: 20, height: 20)
                    Text(name)
                    Spacer()
                    Text(value.hoursMinutesString)
                }
            }
        }
    }
}

private struct PieSliceData: Hashable {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
}

private struct PieSliceView: View {
    let pieSliceData: PieSliceData

    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let width = min(geometry.size.width, geometry.size.height)
                let height = width
                let center: CGPoint = .init(x: width * 0.5, y: height * 0.5)

                path.move(to: center)
                path.addArc(
                    center: center,
                    radius: width * 0.5,
                    startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle,
                    endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle,
                    clockwise: false
                )
            }
            .fill(pieSliceData.color)
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieChartView_Previews: PreviewProvider {
    static let slices: [(value: Double, color: Color, name: String)] = [
        (1300, .blue, ""),
        (500, .green, ""),
        (300, .orange, ""),
    ]
    static var previews: some View {
        PieChartView(slices: slices)
            .previewLayout(.sizeThatFits)
    }
}
