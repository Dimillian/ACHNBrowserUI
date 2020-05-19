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
    let data: [TurnipsChart.YAxis]

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let y = data.first?.minBuyPrice.position.y ?? 0
        path.move(to: CGPoint(x: rect.minX, y: y))
        path.addLine(to: CGPoint(x: rect.maxX, y: y))
        return path
    }
}
