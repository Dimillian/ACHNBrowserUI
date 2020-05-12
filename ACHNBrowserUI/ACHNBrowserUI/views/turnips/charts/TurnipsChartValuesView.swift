//
//  TurnipsChartValuesView.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 12/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartValuesView: View {
    let predictions: TurnipPredictions
    let position: Int
    let padding: CGFloat = 16

    var body: some View {
        GeometryReader(content: values)
    }

    func values(geometry: GeometryProxy) -> some View {
        ZStack {
            Text("\(min)")
                .bold()
                .foregroundColor(.graphMinMax)
                .modifier(ValueModifier(backgroundColor: Color.acBackground))
                .position(positions(geometry: geometry).min)
            Text("\(average)")
                .bold()
                .foregroundColor(.graphAverage)
                .saturation(5)
                .modifier(ValueModifier(backgroundColor: Color.acHeaderBackground))
                .position(positions(geometry: geometry).average)
            Text("\(max)")
                .bold()
                .foregroundColor(.graphMinMax)
                .modifier(ValueModifier(backgroundColor: Color.acBackground))
                .position(positions(geometry: geometry).max)
        }
    }

    var min: Int {
        predictions.minMax?.compactMap { $0.first }[position] ?? 0
    }

    var max: Int {
        predictions.minMax?.compactMap { $0.second }[position] ?? 0
    }

    var average: Int { predictions.averagePrices?[position] ?? 0 }

    typealias Positions = (min: CGPoint, max: CGPoint, average: CGPoint)
    func positions(geometry: GeometryProxy) -> Positions {
        let (_, maxY, ratioY, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: geometry.frame(in: .local)) ?? (0, 0, 0, 0)
        let x = CGFloat(position) * ratioX
        return (
            min: CGPoint(x: x, y: ratioY * (maxY - CGFloat(min)) + padding),
            max: CGPoint(x: x, y: ratioY * (maxY - CGFloat(max)) - padding),
            average: CGPoint(x: x, y: ratioY * (maxY - CGFloat(average)) - padding)
        )
    }
}

extension TurnipsChartValuesView {
    struct ValueModifier: ViewModifier {
        let backgroundColor: Color

        func body(content: Content) -> some View {
            content
                .padding(.horizontal, 8)
                .background(Capsule().fill(backgroundColor.opacity(0.8)))
        }
    }
}

struct TurnipsChartValuesView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }

    private struct Preview: View {
        @State private var position = 5.0
        var body: some View {
            VStack {
                TurnipsChartValuesView(
                    predictions: TurnipsChartView_Previews.predictions,
                    position: Int(position)
                )
                Slider(value: $position, in: 0...11)
            }
        }
    }
}
