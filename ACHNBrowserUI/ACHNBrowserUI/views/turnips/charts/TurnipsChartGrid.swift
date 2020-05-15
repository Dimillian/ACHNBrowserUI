//
//  TurnipsChartGrid.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartGrid: Shape {
    let data: [TurnipsChart.YAxis]
    let displays: Set<Display> = [.vertical, .horizontal]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let (ratioX, ratioY, minY, maxY) = data.ratios(in: rect)
        let count = data.count

        if displays.contains(.vertical) {
            for offset in 0..<count {
                let offset = CGFloat(offset)
                path.move(to: CGPoint(x: offset * ratioX, y: rect.minY))
                path.addLine(to: CGPoint(x: offset * ratioX, y: ratioY * (maxY - minY)))
            }
        }

        if displays.contains(.horizontal) {
            let steps = CGFloat(TurnipsChart.steps)
            let lines = Array(stride(from: minY, to: maxY, by: steps))
            for line in lines {
                path.move(to: CGPoint(x: rect.minX, y: ratioY * line))
                path.addLine(to: CGPoint(x: rect.maxX, y: ratioY * line))
            }
        }

        return path
    }
}

extension TurnipsChartGrid {
    enum Display { case vertical, horizontal }
}

struct TurnipsChartGridInteractiveVerticalLines: View {
    let predictions: TurnipPredictions
    let positionPress: (Int) -> Void
    let touchWidth: CGFloat = 20

    var body: some View {
        GeometryReader(content: lines)
    }

    func lines(geometry: GeometryProxy) -> some View {
        let (_, _, _, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: geometry.frame(in: .local)) ?? (0, 0, 0, 0)
        let count = predictions.minMax?.count ?? 0

        return ZStack(alignment: .leading) {
            ForEach(0..<count) { offset in
                Button(action: { self.positionPress(offset) }) {
                    Color.clear
                        .frame(width: self.touchWidth)
                        .alignmentGuide(.leading, computeValue: { d in -CGFloat(offset) * ratioX })
                }
            }
        }
    }
}
