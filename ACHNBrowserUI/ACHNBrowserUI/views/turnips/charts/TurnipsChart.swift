//
//  TurnipsChart.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

// TODO: refactor by renaming this extension to TurnipsChart namespace
enum TurnipsChart {
    enum PredictionCurve: String {
        case minBuyPrice
        case average
        case minMax

        var color: Color {
            // TODO: replace by proper colors
            switch self {
            case .minBuyPrice: return .green
            case .average: return .yellow
            case .minMax: return .green
            }
        }
    }
}

extension TurnipsChart {

}

extension Array {
    var second: Element? {
        self.count > 1 ? self[1] : nil
    }
}

extension Array where Element == [Int] {
    typealias MinMaxRatios = (min: CGFloat, max: CGFloat, ratioY: CGFloat, ratioX: CGFloat)

    func minMaxAndRatios(
        rect: CGRect
    ) -> (min: CGFloat, max: CGFloat, ratioY: CGFloat, ratioX: CGFloat) {
        let ratioX = rect.maxX/(CGFloat(self.count) - 1)

        let min: CGFloat = self
            .compactMap { $0.first }
            .map(CGFloat.init)
            .min() ?? 0
        let max: CGFloat = self
            .compactMap { $0.second }
            .map(CGFloat.init)
            .max() ?? 0
        let ratioY = rect.maxY/(max - min)

        return (min, max, ratioY, ratioX)
    }
}
