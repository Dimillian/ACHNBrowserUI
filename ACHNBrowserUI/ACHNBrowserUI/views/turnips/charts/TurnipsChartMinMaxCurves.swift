//
//  TurnipsChartMinMaxCurves.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartMinMaxCurves: Shape {
    let predictions: TurnipPredictions
    var animationStep: CGFloat = 1

    var animatableData: CGFloat {
        get { animationStep }
        set { animationStep = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let minMax = predictions.minMax else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }
        let (_, maxY, ratioY, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)

        let minPoints: [CGPoint] = minMax
            .compactMap { $0.first }
            .enumerated()
            .map({ offset, minValue in
                let x = ratioX * CGFloat(offset)
                let y = ratioY * (maxY - CGFloat(minValue) * animationStep)
                return CGPoint(x: x, y: y)
            })
        path.addHermiteCurvedLines(points: minPoints)

        let maxPoints: [CGPoint] = minMax
            .compactMap { $0.second }
            .enumerated()
            .map({ offset, maxValue in
                let x = ratioX * CGFloat(offset)
                let y = ratioY * (maxY - CGFloat(maxValue) * animationStep)
                return CGPoint(x: x, y: y)
            })
            .reversed()
        path.addLine(to: maxPoints.first ?? .zero)
        path.addHermiteCurvedLines(points: maxPoints)
        path.addLine(to: minPoints.first ?? .zero)

        return path
    }
}

struct TurnipsChartMinMaxCurves_Previews: PreviewProvider {
    static var previews: some View {
        Preview().padding()
    }

    private struct Preview: View {
        @State private var animationStep: CGFloat = 1

        var body: some View {
            VStack {
                TurnipsChartMinMaxCurves(
                    predictions: TurnipsChartView_Previews.predictions,
                    animationStep: animationStep
                )
                    .foregroundColor(TurnipsChart.PredictionCurve.minMax.color)
                    .opacity(0.25)
                    .blendMode(.darken)
                Slider(value: $animationStep, in: 0.1...1)
            }
        }
    }
}
