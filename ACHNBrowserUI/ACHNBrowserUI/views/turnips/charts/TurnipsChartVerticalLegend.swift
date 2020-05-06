//
//  TurnipsChartVerticalLegend.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 05/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartVerticalLegend: View {
    let predictions: TurnipPredictions

    var body: some View {
        GeometryReader(content: texts)
    }

    func texts(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .local)
        let (minY, maxY, ratioY, _) = predictions.minMax?.roundedMinMaxAndRatios(rect: frame) ?? (0, 0, 0, 0)

        return ZStack {
            ForEach(Array(stride(from: Int(minY), to: Int(maxY), by: TurnipsChart.steps)), id: \.self) { value in
                Text("\(value)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.text)
                    .position(x: frame.midX, y: (maxY - CGFloat(value)) * ratioY)
            }
        }
    }
}
