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
        GeometryReader(content: computeTexts)
    }

    func computeTexts(geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .local)
        let (minY, maxY, ratioY, _) = predictions.minMax?.roundedMinMaxAndRatios(rect: frame) ?? (0, 0, 0, 0)

        let min = Int(minY)
        let max = Int(maxY) + TurnipsChart.steps
        let values = Array(stride(from: min, to: max, by: TurnipsChart.steps))
        return texts(values: values, ratioY: ratioY)
    }

    func texts(values: [Int], ratioY: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            ForEach(values, id: \.self) { value in
                Text("\(value)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.text)
                    .alignmentGuide(.top) { d in CGFloat(value) * ratioY }
            }
        }
    }
}
