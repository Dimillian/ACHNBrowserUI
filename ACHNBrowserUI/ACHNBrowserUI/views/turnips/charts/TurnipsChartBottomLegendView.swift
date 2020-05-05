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
    let predictions: TurnipPredictions
    private let weekdays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

    var body: some View {
        GeometryReader(content: texts)
    }

    func texts(for geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .local)
        let (_, _, _, ratioX) = predictions.minMax?.minMaxAndRatios(rect: frame) ?? (0, 0, 0, 0)
        let count = predictions.minMax?.count ?? 0

        return VStack {
            ZStack {
                ForEach(0..<count) { offset in
                    self.yAxisText(offset: offset, ratioX: ratioX, frame: frame)
                }
            }
            ZStack {
                ForEach(Array(weekdays.enumerated()), id: \.0) { offset, weekday in
                    // TODO: investigate AlignmentGuide instead of guessing the exact position
                    Text(weekday)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.text)
                        .position(x: CGFloat(offset + 1) * ratioX/2 + CGFloat(offset) * ratioX * 1.5, y: frame.midY)
                }
            }
        }
    }

    // TODO: investigate AlignmentGuide instead of guessing the exact position
    func yAxisText(offset: Int, ratioX: CGFloat, frame: CGRect) -> some View {
        let isAM = offset == 0 || offset.isMultiple(of: 2)
        return Text(isAM ? "AM" : "PM")
            .font(.footnote)
            .fontWeight(.semibold)
            .foregroundColor(.text)
            .position(x: CGFloat(offset) * ratioX, y: frame.midY)
    }
}
