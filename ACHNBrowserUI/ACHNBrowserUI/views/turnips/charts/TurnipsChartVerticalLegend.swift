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
    let data: [TurnipsChart.YAxis]

    var body: some View {
        GeometryReader(content: computeTexts)
    }

    func computeTexts(geometry: GeometryProxy) -> some View {
        let rect = geometry.frame(in: .local)
        let (_, ratioY, minY, maxY) = data.ratios(in: rect)

        let steps = CGFloat(TurnipsChart.steps)
        let values = Array(stride(from: minY, to: maxY + CGFloat(TurnipsChart.extraMaxSteps), by: steps))
        return texts(values: values, ratioY: ratioY)
            .propagate({ $0.width }, using: WidthPreferenceKey.self)
        
    }

    func texts(values: [CGFloat], ratioY: CGFloat) -> some View {
        ZStack(alignment: .topTrailing) {
            ForEach(values, id: \.self) { value in
                Text("\(Int(value))")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .fixedSize()
                    .foregroundColor(.acText)
                    .alignmentGuide(.top) { d in value * ratioY }
            }
        }
    }
}

extension TurnipsChartVerticalLegend {
    struct WidthPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat?
        static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
            if let newValue = nextValue() { value = newValue }
        }
    }
}
