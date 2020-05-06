//
//  TurnipsChartAverageCurve.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartAverageCurve: Shape {
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let averagePrices = predictions.averagePrices else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }

        let (_, maxY, ratioY, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)

        let points = averagePrices.enumerated().map { offset, average -> CGPoint in
            let x = ratioX * CGFloat(offset)
            let y = ratioY * (maxY - CGFloat(average))
            return CGPoint(x: x, y: y)
        }
        path.addLines(points)

        return path
    }
}
