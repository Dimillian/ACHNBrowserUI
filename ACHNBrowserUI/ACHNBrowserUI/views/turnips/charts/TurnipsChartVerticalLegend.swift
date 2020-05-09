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

        let min = Int(minY)
        let max = Int(maxY) + TurnipsChart.steps
        let values = Array(stride(from: min, to: max, by: TurnipsChart.steps))

        return ZStack(alignment: .verticalLegendAlignment) {
            ForEach(values, id: \.self) { value in
                Text("\(value)")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.text)
                    .alignmentGuide(.verticalLegendAlignment) { d in CGFloat(value) * ratioY }
            }.background(Color.red)
        }.background(Color.blue)
    }
}
