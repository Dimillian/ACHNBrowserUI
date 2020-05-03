//
//  TurnipsChartMinBuyPriceCurve.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartMinBuyPriceCurve: Shape {
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let minBuyPrice = predictions.minBuyPrice else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }

        let (_, maxY, ratioY, _) = predictions.minMax?.minMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)

        let y = ratioY * (maxY - CGFloat(minBuyPrice))
        path.move(to: CGPoint(x: rect.minX, y: y))
        path.addLine(to: CGPoint(x: rect.maxX, y: y))
        return path
    }
}
