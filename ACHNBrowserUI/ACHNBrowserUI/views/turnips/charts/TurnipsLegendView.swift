//
//  TurnipsLegendView.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsLegendView: View {
    let predictions: TurnipPredictions

    var body: some View {
        GeometryReader(content: texts)
            .background(Color.yellow.opacity(0.1))
    }

    func texts(for geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .local)
        let (minY, maxY, ratioY, _) = predictions.minMax?.minMaxAndRatios(rect: frame) ?? (0, 0, 0, 0)
        let buyPrice = predictions.minBuyPrice ?? 0

        return ZStack {
            Text("\(Int(minY))")
                .foregroundColor(TurnipsChartView.PredictionCurve.minMax.color)
                .position(x: frame.midX, y: ratioY * (maxY - minY))
            Text("\(Int(buyPrice))")
                .foregroundColor(TurnipsChartView.PredictionCurve.minBuyPrice.color)
                .position(x: frame.midX, y: ratioY * (maxY - CGFloat(buyPrice)))
            Text("\(Int(maxY))")
                .foregroundColor(TurnipsChartView.PredictionCurve.minMax.color)
                .position(x: frame.midX, y: 0)
        }
    }
}
