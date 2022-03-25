//
//  PieChartView.swift
//  Busyless
//
//  Created by Derrick Showers on 3/21/22.
//  Copyright © 2022 Derrick Showers. All rights reserved.
//

import SwiftUI

struct PieChartViewData: Hashable {
    let name: String
    let value: Double
    let color: Color
}

struct PieChartView: View {
    let slices: [PieChartViewData]

    @State private var activeSlice: PieSliceData?

    private var slicesData: [PieSliceData] {
        let values = slices.map { $0.value }
        let sum = values.reduce(0, +)
        var endDegrees: Double = 0
        var tempSlices: [PieSliceData] = []

        slices.forEach { viewData in
            let degrees = viewData.value * 360 / sum
            tempSlices.append(PieSliceData(
                startAngle: Angle(degrees: endDegrees),
                endAngle: Angle(degrees: endDegrees + degrees),
                color: viewData.color
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
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height
                )

                Circle()
                    .fill(.white)
                    .frame(
                        width: geometry.size.width * 0.6,
                        height: geometry.size.width * 0.6
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

struct PieChartRows: View {
    let slices: [PieChartViewData]

    var body: some View {
        VStack {
            ForEach(slices, id: \.name) { viewData in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(viewData.color)
                        .frame(width: 20, height: 20)
                    Text(viewData.name)
                    Spacer()
                    Text(viewData.value.hoursMinutesString)
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
    }
}

struct PieChartView_Previews: PreviewProvider {
    static let slices: [PieChartViewData] = [
        PieChartViewData(name: "", value: 1300, color: .blue),
        PieChartViewData(name: "", value: 500, color: .green),
        PieChartViewData(name: "", value: 300, color: .orange),
    ]
    static var previews: some View {
        PieChartView(slices: slices)
            .previewLayout(.sizeThatFits)
    }
}
