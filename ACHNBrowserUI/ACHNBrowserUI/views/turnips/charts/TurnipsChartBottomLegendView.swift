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
    let data: [TurnipsChart.YAxis]
    let positionPress: (Int) -> Void
    private let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    
    @State private var textsHeight: CGFloat?

    var body: some View {
        texts(xValues: data.map { $0.minBuyPrice.position.x })
            .propagate({ $0.height }, using: HeightPreferenceKey.self)
    }

    func texts(xValues: [CGFloat]) -> some View {
        VStack {
            ZStack(alignment: .leading) {
                ForEach(Array(xValues.enumerated()), id: \.0) { offset, x in
                    self.meridiem(offset: offset, x: -x)
                }
            }
            ZStack(alignment: .leading) {
                ForEach(Array(weekdays.enumerated()), id: \.0) { offset, weekday in
                    self.weekdays(offset: offset, weekday: weekday, x: -xValues[offset * 2 + 1])
                }
            }
        }
    }

    func meridiem(offset: Int, x: CGFloat) -> some View {
        Button(action: { self.positionPress(offset) }) {
            Text(offset.isAM ? "AM" : "PM")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.acText)
                .alignmentGuide(.leading, computeValue: { _ in x })
        }
    }

    func weekdays(offset: Int, weekday: String, x: CGFloat) -> some View {
        Text(LocalizedStringKey(weekday))
            .font(.callout)
            .fontWeight(.bold)
            .foregroundColor(.acText)
            .alignmentGuide(.leading, computeValue: { d in x + d.width/2 })
    }
}

extension TurnipsChartBottomLegendView {
    struct HeightPreferenceKey: PreferenceKey {
        static var defaultValue: CGFloat?
        static func reduce(value: inout CGFloat?, nextValue: () -> CGFloat?) {
            if let newValue = nextValue() { value = newValue }
        }
    }
}

private extension Int {
    var isAM: Bool { self == 0 || isMultiple(of: 2) }
}

struct TurnipsChartBottomLegendView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            TurnipsChartBottomLegendView(
                data: TurnipsChartView_Previews.yAxisData(for: geometry),
                positionPress: { _ in }
            )
        }
    }
}
