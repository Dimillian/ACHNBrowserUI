//
//  TurnipsChartView.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 02/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartView: View {
    typealias PredictionCurve = TurnipsChart.PredictionCurve
    static let verticalLinesCount: CGFloat = 9
    var predictions: TurnipPredictions

    var body: some View {
        HStack(spacing: 0) {
            TurnipsChartLegendView(predictions: predictions)
                .frame(maxWidth: 40) // FIXME: should use something more dynamic
            ZStack {
                TurnipsChartGridView(predictions: predictions)
                    .stroke()
                    .opacity(0.5)
                TurnipsAverageCurve(predictions: predictions)
                    .stroke(lineWidth: 2)
                    .foregroundColor(PredictionCurve.average.color)
                TurnipsBuyPrice(predictions: predictions)
                    .stroke(style: StrokeStyle(dash: [Self.verticalLinesCount]))
                    .foregroundColor(PredictionCurve.minBuyPrice.color)
                TurnipsMinMaxCurves(predictions: predictions)
                    .foregroundColor(PredictionCurve.minMax.color)
                    .opacity(0.25)
            }.background(Color.blue.opacity(0.1))
        }
    }
}

struct TurnipsAverageCurve: Shape {
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let averagePrices = predictions.averagePrices else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }

        let (_, maxY, ratioY, ratioX) = predictions.minMax?.minMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)

        let points = averagePrices.enumerated().map { offset, average -> CGPoint in
            let x = ratioX * CGFloat(offset)
            let y = ratioY * (maxY - CGFloat(average))
            return CGPoint(x: x, y: y)
        }
        path.addLines(points)

        return path
    }
}

struct TurnipsMinMaxCurves: Shape {
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let minMax = predictions.minMax else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }
        let (_, maxY, ratioY, ratioX) = predictions.minMax?.minMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)
        print(minMax)

        let minPoints: [CGPoint] = minMax
            .compactMap { $0.first }
            .enumerated()
            .map({ offset, minValue in
                let x = ratioX * CGFloat(offset)
                let y = ratioY * (maxY - CGFloat(minValue))
                return CGPoint(x: x, y: y)
            })
        path.addLines(minPoints)

        let maxPoints: [CGPoint] = minMax
            .compactMap { $0.second }
            .enumerated()
            .map({ offset, maxValue in
                let x = ratioX * CGFloat(offset)
                let y = ratioY * (maxY - CGFloat(maxValue))
                return CGPoint(x: x, y: y)
            })
            .reversed()
        path.addLine(to: maxPoints.first ?? .zero)
        path.addLines(maxPoints)

        path.addLine(to: minPoints.first ?? .zero)

        return path
    }
}

struct TurnipsBuyPrice: Shape {
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let minBuyPrice = predictions.minBuyPrice else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }

        let (_, maxY, ratioY, _) = predictions.minMax?.minMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)

        let y = ratioY * (maxY - CGFloat(minBuyPrice))
        path.move(to: CGPoint(x: rect.minX, y: y))
        path.addLine(to: CGPoint(x: rect.maxX, y: y))
        return path
    }
}

struct TurnipsChartView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsChartView(predictions: TurnipPredictions(
            minBuyPrice: 83,
            averagePrices: averagePrices,
            minMax: minMax)
        ).padding()
    }

    static let averagePrices = [89, 85, 88, 104, 110, 111, 111, 111, 106, 98, 82, 77]

    static let minMax = [[38, 142], [33, 142], [29, 202], [24, 602], [19, 602], [14, 602], [9, 602], [29, 602], [24, 602], [19, 602], [14, 202], [9, 201]]
}
