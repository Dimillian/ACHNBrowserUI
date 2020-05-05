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
    private let steps = 50

    var body: some View {
        GeometryReader(content: h)
    }

    func h(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .local)
        let (minY, maxY, ratioY, _) = predictions.minMax?.minMaxAndRatios(rect: frame) ?? (0, 0, 0, 0)

        let roundedMin = Int(minY)/steps * steps
        let roundedMax = (Int(maxY) + steps)/steps * steps
        return ZStack {
            ForEach(Array(stride(from: roundedMin, to: roundedMax, by: steps)), id: \.self) { value in
                Text("\(value)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.text)
                    .position(x: frame.midX, y: (maxY - CGFloat(value)) * ratioY)
            }
        }
    }
}
