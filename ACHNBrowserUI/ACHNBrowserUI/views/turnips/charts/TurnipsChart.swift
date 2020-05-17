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
    static let extraMinSteps = 0
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

        let (ratioX, ratioY, _, maxY) = ratios(size: size, count: count, min: min, max: max)

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
}

extension TurnipsChart {
    typealias Ratios = (ratioX: CGFloat, ratioY: CGFloat, minY: CGFloat, maxY: CGFloat)

    static func ratios(size: CGSize, count: Int, min: Int, max: Int) -> Ratios {
        let ratioX = size.width/(CGFloat(count - 1))

        let steps = TurnipsChart.steps

        let computedRoundedMin = Int(min)/steps * steps - TurnipsChart.extraMinSteps
        let roundedMin = Swift.max(0, computedRoundedMin)
        let roundedMax = Int(max)/steps * steps + TurnipsChart.extraMaxSteps
        let ratioY = size.height/CGFloat(roundedMax - roundedMin)

        return (ratioX, ratioY, CGFloat(roundedMin), CGFloat(roundedMax))
    }
}

extension Array {
    var second: Element? {
        self.count > 1 ? self[1] : nil
    }
}

extension Array where Element == TurnipsChart.YAxis {
    func ratios(in rect: CGRect) -> TurnipsChart.Ratios {
        let min = self.compactMap { $0.min.value }.min() ?? 0
        let max = self.compactMap { $0.max.value }.max() ?? 0

        return TurnipsChart.ratios(size: rect.size, count: count, min: min, max: max)
    }
}
