//
//  TurnipsChartAverageCurve.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartAverageCurve: Shape {
    let predictions: TurnipPredictions
    var animationStep: CGFloat = 1

    var animatableData: CGFloat {
        get { animationStep }
        set { animationStep = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let averagePrices = predictions.averagePrices else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }

        let (_, maxY, ratioY, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)

        let points = averagePrices.enumerated().map { offset, average -> CGPoint in
            let x = ratioX * CGFloat(offset)
            let y = ratioY * (maxY - CGFloat(average))
            return CGPoint(x: x, y: y)
        }
        path.addLines(points)

        return path.trimmedPath(from: 0, to: animationStep)
    }
}


struct TurnipsChartAverageCurve_Previews: PreviewProvider {
    static var previews: some View {
        Preview().padding()
    }

    private struct Preview: View {
        @State private var animationStep: CGFloat = 1

        var body: some View {
            VStack {
                TurnipsChartAverageCurve(
                    predictions: TurnipsChartView_Previews.predictions,
                    animationStep: animationStep
                )
                    .stroke(lineWidth: 3)
                    .foregroundColor(TurnipsChart.PredictionCurve.average.color)
                    .saturation(5)
                Slider(value: $animationStep, in: 0...1)
            }
        }
    }
}
