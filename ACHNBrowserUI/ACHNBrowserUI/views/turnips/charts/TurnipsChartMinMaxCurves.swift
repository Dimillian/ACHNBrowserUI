//
//  TurnipsChartMinMaxCurves.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartMinMaxCurves: Shape {
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let minMax = predictions.minMax else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }
        let (_, maxY, ratioY, ratioX) = predictions.minMax?.minMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)

        let minPoints: [CGPoint] = minMax
            .compactMap { $0.first }
            .enumerated()
            .map({ offset, minValue in
                let x = ratioX * CGFloat(offset)
                let y = ratioY * (maxY - CGFloat(minValue))
                return CGPoint(x: x, y: y)
            })
        path.addLines(minPoints)

        let maxPoints: [CGPoint] = minMax
            .compactMap { $0.second }
            .enumerated()
            .map({ offset, maxValue in
                let x = ratioX * CGFloat(offset)
                let y = ratioY * (maxY - CGFloat(maxValue))
                return CGPoint(x: x, y: y)
            })
            .reversed()
        path.addLine(to: maxPoints.first ?? .zero)
        path.addLines(maxPoints)

        path.addLine(to: minPoints.first ?? .zero)

        return path
    }
}
