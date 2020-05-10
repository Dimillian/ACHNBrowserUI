//
//  TurnipsChart.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

enum TurnipsChart {
    static let steps = 50
    static let extraMinSteps = 50
    static let extraMaxSteps = 50

    enum PredictionCurve: String {
        case minBuyPrice
        case average
        case minMax

        var color: Color {
            switch self {
            case .minBuyPrice: return .graphMinimum
            case .average: return .graphAverage
            case .minMax: return .graphMinMax
            }
        }
    }
}

extension Array {
    var second: Element? {
        self.count > 1 ? self[1] : nil
    }
}

extension Array where Element == [Int] {
    typealias MinMaxRatios = (min: CGFloat, max: CGFloat, ratioY: CGFloat, ratioX: CGFloat)

    private func minMaxAndRatios(
        rect: CGRect
    ) -> (min: CGFloat, max: CGFloat, ratioY: CGFloat, ratioX: CGFloat) {
        let ratioX = rect.maxX/(CGFloat(self.count - 1))

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

    func roundedMinMaxAndRatios(
        rect: CGRect
    ) -> (minY: CGFloat, max: CGFloat, ratioY: CGFloat, ratioX: CGFloat) {
        let (minY, maxY, _, ratioX) = minMaxAndRatios(rect: rect)

        let steps = TurnipsChart.steps
        let extraMinSteps = TurnipsChart.extraMinSteps
        let extraMaxSteps = TurnipsChart.extraMaxSteps

        let computedRoundedMin = Int(minY)/steps * steps - extraMinSteps
        let roundedMin = Swift.max(0, computedRoundedMin)
        let roundedMax = (Int(maxY) + steps)/steps * steps + extraMaxSteps
        let ratioY = rect.maxY/CGFloat(roundedMax - roundedMin)

        return (CGFloat(roundedMin), CGFloat(roundedMax), ratioY, ratioX)
    }
}
