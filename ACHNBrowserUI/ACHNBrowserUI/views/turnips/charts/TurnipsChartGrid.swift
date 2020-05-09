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

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let (minY, maxY, ratioY, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)
        let count = predictions.minMax?.count ?? 0

        for offset in 0..<count {
            let offset = CGFloat(offset)
            path.move(to: CGPoint(x: offset * ratioX, y: rect.minY))
            path.addLine(to: CGPoint(x: offset * ratioX, y: ratioY * (maxY - minY)))
        }

        return path
    }
}
