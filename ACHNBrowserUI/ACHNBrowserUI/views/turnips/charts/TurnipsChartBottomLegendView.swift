//
//  TurnipsLegendView.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartBottomLegendView: View {
    struct HeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat?
        static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
            if let newValue = nextValue() { value = newValue }
        }
    }
    
    let predictions: TurnipPredictions
    private let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    @State private var textsHeight: CGFloat?

    var body: some View {
        GeometryReader(content: computeTexts)
    }

    func computeTexts(for geometry: GeometryProxy) -> some View {
        
        let rect = geometry.frame(in: .local)
        let (_, _, _, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)
        let count = predictions.minMax?.count ?? 0
        return texts(count: count, ratioX: ratioX)
            .propagateHeight(HeightPreferenceKey.self)
    }

    func texts(count: Int, ratioX: CGFloat) -> some View {
        VStack {
            ZStack(alignment: .leading) {
                ForEach(0..<count) { offset in
                    self.meridiem(offset: offset, ratioX: ratioX)
                }
            }
            ZStack(alignment: .leading) {
                ForEach(Array(weekdays.enumerated()), id: \.0) { offset, weekday in
                    self.weekdays(offset: offset, weekday: weekday, ratioX: ratioX)
                }
            }
        }
        
    }

    func meridiem(offset: Int, ratioX: CGFloat) -> some View {
        Text(offset.isAM ? "AM" : "PM")
            .font(.footnote)
            .fontWeight(.semibold)
            .foregroundColor(.acText)
            .alignmentGuide(.leading, computeValue: { d in
                -CGFloat(offset) * ratioX
            })
    }

    func weekdays(offset: Int, weekday: String, ratioX: CGFloat) -> some View {
        Text(LocalizedStringKey(weekday))
            .font(.callout)
            .fontWeight(.bold)
            .foregroundColor(.acText)
            .alignmentGuide(.leading, computeValue: { d in
                -CGFloat(offset * 2 + 1) * ratioX + d.width/2
            })
    }
}

private extension Int {
    var isAM: Bool { self == 0 || isMultiple(of: 2) }
}

struct TurnipsChartBottomLegendView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsChartBottomLegendView(predictions: TurnipsChartView_Previews.predictions)
    }
}
