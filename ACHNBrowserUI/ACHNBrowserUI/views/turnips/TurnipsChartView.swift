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
    static let verticalLinesCount: CGFloat = 9
    var predictions: TurnipPredictions

    var body: some View {
        HStack(spacing: 0) {
            TurnipsLegend(predictions: predictions)
                .frame(maxWidth: 40) // FIXME: should use something more dynamic
            ZStack {
                TurnipsGrid(predictions: predictions)
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

struct TurnipsLegend: View {
    let predictions: TurnipPredictions

    var body: some View {
        GeometryReader(content: texts)
            .background(Color.yellow.opacity(0.1))
    }

    func texts(for geometry: GeometryProxy) -> some View {
        let frame = geometry.frame(in: .local)
        let (minY, maxY, ratioY) = minMaxAndRatioY(for: predictions, rect: frame)
        let buyPrice = predictions.minBuyPrice ?? 0

        return ZStack {
            Text("\(Int(minY))")
                .foregroundColor(TurnipsChartView.PredictionCurve.minMax.color)
                .position(x: frame.midX, y: ratioY * (maxY - minY))
            Text("\(Int(buyPrice))")
                .foregroundColor(TurnipsChartView.PredictionCurve.minBuyPrice.color)
                .position(x: frame.midX, y: ratioY * (maxY - CGFloat(buyPrice)))
            Text("\(Int(maxY))")
                .foregroundColor(TurnipsChartView.PredictionCurve.minMax.color)
                .position(x: frame.midX, y: 0)
        }
    }
}

struct TurnipsGrid: Shape {
    static let averagesCount: CGFloat = 12
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let (minY, maxY, ratioY) = minMaxAndRatioY(for: predictions, rect: rect)

        let ratioX = rect.maxX/(Self.averagesCount - 1)
        for offset in 0..<Int(Self.averagesCount) {
            let offset = CGFloat(offset)
            path.move(to: CGPoint(x: offset * ratioX, y: rect.minY))
            path.addLine(to: CGPoint(x: offset * ratioX, y: ratioY * (maxY - minY)))
        }

        let steps = (maxY - minY)/TurnipsChartView.verticalLinesCount
        for offset in stride(from: minY, to: maxY, by: steps) {
            let offset = CGFloat(offset)
            path.move(to: CGPoint(x: rect.minX, y: (offset - minY) * ratioY))
            path.addLine(to: CGPoint(x: rect.maxX, y: (offset - minY) * ratioY))
        }
        path.move(to: CGPoint(x: rect.minX, y: (maxY - minY) * ratioY))
        path.addLine(to: CGPoint(x: rect.maxX, y: (maxY - minY) * ratioY))

        return path
    }
}

struct TurnipsAverageCurve: Shape {
    static let averagesCount: CGFloat = 12
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let averagePrices = predictions.averagePrices else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }

        let (minY, maxY, ratioY) = minMaxAndRatioY(for: predictions, rect: rect)
        let ratioX = rect.maxX/(Self.averagesCount - 1)

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
    static let minMaxCount: CGFloat = 12
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let minMax = predictions.minMax else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }
        let (minY, maxY, ratioY) = minMaxAndRatioY(for: predictions, rect: rect)
        print(minMax)

        let ratioX = rect.maxX/(Self.minMaxCount - 1)

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

        let (minY, maxY, ratioY) = minMaxAndRatioY(for: predictions, rect: rect)

        let y = ratioY * (maxY - CGFloat(minBuyPrice))
        path.move(to: CGPoint(x: rect.minX, y: y))
        path.addLine(to: CGPoint(x: rect.maxX, y: y))
        return path
    }
}

// TODO: Put this function into a namespace
fileprivate func minMaxAndRatioY(
    for predictions: TurnipPredictions,
    rect: CGRect
) -> (min: CGFloat, max: CGFloat, ratioY: CGFloat) {
    guard let minMax = predictions.minMax else {
            // Maybe we should just crash as it shouldn't happen
            return (0, 0, 0)
    }
    let min: CGFloat = minMax
        .compactMap { $0.first }
        .map(CGFloat.init)
        .min() ?? 0
    let max: CGFloat = minMax
        .compactMap { $0.second }
        .map(CGFloat.init)
        .max() ?? 0
    let ratioY = rect.maxY/(max - min)

    return (min, max, ratioY)
}

extension TurnipsChartView {
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

extension Array {
    var second: Element? {
        self.count > 1 ? self[1] : nil
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
