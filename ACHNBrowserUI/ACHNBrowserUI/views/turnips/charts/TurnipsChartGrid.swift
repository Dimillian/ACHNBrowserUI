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
    let predictions: TurnipPredictions
    // TODO: put only .vertical after tests
    let displays: Set<Display> = [.vertical, .horizontal]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let (minY, maxY, ratioY, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)
        let count = predictions.minMax?.count ?? 0

        if displays.contains(.vertical) {
            for offset in 0..<count {
                let offset = CGFloat(offset)
                path.move(to: CGPoint(x: offset * ratioX, y: rect.minY))
                path.addLine(to: CGPoint(x: offset * ratioX, y: ratioY * (maxY - minY)))
            }
        }

        if displays.contains(.horizontal) {
            let min = Int(minY)
            let max = Int(maxY) + TurnipsChart.steps
            let lines = Array(stride(from: min, to: max, by: TurnipsChart.steps))
            for line in lines {
                let line = CGFloat(line)
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

extension VerticalAlignment {
    private enum VerticalLegendAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[VerticalAlignment.center]
        }
    }
    static let verticalLegendAlignment = VerticalAlignment(VerticalLegendAlignment.self)
}

extension Alignment {
    static let verticalLegendAlignment = Alignment(horizontal: .trailing, vertical: .verticalLegendAlignment)
}
