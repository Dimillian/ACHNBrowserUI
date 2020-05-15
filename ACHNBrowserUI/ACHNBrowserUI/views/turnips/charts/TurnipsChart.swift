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
}

extension TurnipsChart {
    struct YAxis {
        var min: (value: Int, position: CGPoint)
        var max: (value: Int, position: CGPoint)
        var average: (value: Int, position: CGPoint)
        var minBuyPrice: (value: Int, position: CGPoint)
    }

    static func data(for predictions: TurnipPredictions, size: CGSize) -> [YAxis] {
        guard
            let minMax = predictions.minMax,
            let averages = predictions.averagePrices,
            let minimumBuyPrice = predictions.minBuyPrice
            else {
                return []
        }

        let minimums = minMax.compactMap { $0.first }
        let maximums = minMax.compactMap { $0.second }

        let min = minimums.min() ?? 0
        let max = maximums.max() ?? 0

        let count = minMax.count

        let (ratioX, ratioY, maxY) = ratios(size: size, count: count, min: min, max: max)

        return Array(0..<count)
            .map({ index in
                let x = CGFloat(index) * ratioX
                let minPosition = CGPoint(x: x, y: (maxY - CGFloat(minimums[index])) * ratioY)
                let maxPosition = CGPoint(x: x, y: (maxY - CGFloat(maximums[index])) * ratioY)
                let averagePosition = CGPoint(x: x, y: (maxY - CGFloat(averages[index])) * ratioY)
                let minimumBuyPricePosition = CGPoint(x: x, y: (maxY - CGFloat(minimumBuyPrice)) * ratioY)

                return YAxis(
                    min: (value: minimums[index], position: minPosition),
                    max: (value: maximums[index], position: maxPosition),
                    average: (value: averages[index], position: averagePosition),
                    minBuyPrice: (value: minimumBuyPrice, position: minimumBuyPricePosition)
                )
            })
    }

    private static func ratios(
        size: CGSize,
        count: Int,
        min: Int,
        max: Int
    ) -> (ratioX: CGFloat, ratioY: CGFloat, maxY: CGFloat) {
        let ratioX = size.width/(CGFloat(count - 1))

        let steps = TurnipsChart.steps
        let extraMinSteps = TurnipsChart.extraMinSteps
        let extraMaxSteps = TurnipsChart.extraMaxSteps

        let computedRoundedMin = Int(min)/steps * steps - extraMinSteps
        let roundedMin = Swift.max(0, computedRoundedMin)
        let roundedMax = (Int(max) + steps)/steps * steps + extraMaxSteps
        let ratioY = size.height/CGFloat(roundedMax - roundedMin)

        return (ratioX, ratioY, CGFloat(roundedMax))
    }
}

extension Array {
    var second: Element? {
        self.count > 1 ? self[1] : nil
    }
}

extension Array where Element == TurnipsChart.YAxis {
    func ratios(in rect: CGRect) -> (x: CGFloat, y: CGFloat, minY: CGFloat, maxY: CGFloat) {
        let ratioX = rect.maxX/(CGFloat(self.count - 1))

        let minY = CGFloat(self.compactMap { $0.min.value }.min() ?? 0)
        let maxY = CGFloat(self.compactMap { $0.max.value }.max() ?? 0)

        let steps = CGFloat(TurnipsChart.steps)
        let extraMinSteps = CGFloat(TurnipsChart.extraMinSteps)
        let extraMaxSteps = CGFloat(TurnipsChart.extraMaxSteps)

        let computedRoundedMin = minY/steps * steps - extraMinSteps
        let roundedMin = Swift.max(0, computedRoundedMin)
        let roundedMax = (maxY + steps)/steps * steps + extraMaxSteps
        let roundedRatioY = rect.maxY/(roundedMax - roundedMin)

        return (ratioX, roundedRatioY, roundedMin, roundedMax)
    }
}

// TODO: Remove this, should be useless after the refactoring
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
