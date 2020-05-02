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
    var predictions: TurnipPredictions

    var body: some View {
        VStack {
            Text("Turnips chart of the week")
            Spacer()
            curves.padding()
        }
    }

    var curves: some View {
        HStack {
            TurnipsLegend(predictions: predictions)
                .frame(maxWidth: 40)
            ZStack {
                TurnipsGrid(predictions: predictions)
                    .stroke()
                    .opacity(0.5)
                TurnipsAverageCurve(predictions: predictions)
                    .stroke(lineWidth: 2)
                TurnipsBuyPrice(predictions: predictions)
                    .stroke(lineWidth: 5)
            }.background(Color.blue.opacity(0.1))
        }
    }
}

struct TurnipsLegend: View {
    let predictions: TurnipPredictions

    var body: some View {
        // TODO: this is ugly and should be refactored with some functions and computed var
        GeometryReader<AnyView> { geometry in
            let frame = geometry.frame(in: .local)
            let (minY, maxY, ratioY) = minMaxAndRatioY(for: self.predictions, rect: frame)
            return AnyView(
                ZStack {
                ForEach(Array(stride(from: minY, to: maxY, by: 50)), id: \.self) { value in
                    Text("\(Int(value))")
                        .offset(x: 0, y: ratioY * (value - minY))
                        .offset(x: 0, y: -10) // FIXME: hardcoded value here! Should be computed
                }
                Text("\(Int(maxY))")
                    .offset(x: 0, y: ratioY * (maxY - minY))
                    .offset(x: 0, y: -10) // FIXME: hardcoded value here! Should be computed
                }
            )
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

        for offset in stride(from: minY, to: maxY, by: 50) {
            let offset = CGFloat(offset)
            path.move(to: CGPoint(x: rect.minX, y: (offset - minY) * ratioY))
            path.addLine(to: CGPoint(x: rect.maxX, y: (offset - minY) * ratioY))
        }
        path.move(to: CGPoint(x: rect.minX, y: (maxY - minY) * ratioY))
        path.addLine(to: CGPoint(x: rect.maxX, y: (maxY - minY) * ratioY))

        return path
    }
}

struct TurnipsChartView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsChartView(predictions: TurnipPredictions(
            minBuyPrice: 104,
            averagePrices: averagePrices,
            minMax: minMax)
        )
    }

    static let averagePrices = [104, 93, 87, 88, 106, 110, 90, 74, 76, 91, 98, 96]

    static let minMax = [[40, 148], [89, 148], [61, 148], [61, 86], [50, 148], [40, 210], [50, 626], [40, 626], [40, 626], [40, 626], [35, 210], [30, 209]]
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
            let y = ratioY * (CGFloat(average) - minY)
            return CGPoint(x: x, y: y)
        }
        path.addLines(points)

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

        let (min, max, ratioY) = minMaxAndRatioY(for: predictions, rect: rect)

        let y = ratioY * (CGFloat(minBuyPrice) - min)
        path.move(to: CGPoint(x: rect.minX, y: y))
        path.addLine(to: CGPoint(x: rect.maxX, y: y))
        return path
    }
}

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

extension Array {
    var second: Element? {
        self.count > 1 ? self[1] : nil
    }
}
