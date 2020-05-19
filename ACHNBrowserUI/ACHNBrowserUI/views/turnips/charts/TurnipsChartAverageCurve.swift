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
    let data: [TurnipsChart.YAxis]
    var animationStep: CGFloat = 1

    var animatableData: CGFloat {
        get { animationStep }
        set { animationStep = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let points = data.map { $0.average.position }
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
                GeometryReader {
                    TurnipsChartAverageCurve(
                        data: TurnipsChartView_Previews.yAxisData(for: $0),
                        animationStep: self.animationStep
                    )
                        .stroke(lineWidth: 3)
                        .foregroundColor(.graphAverage)
                        .saturation(5)
                }
                Slider(value: $animationStep, in: 0...1)
            }
        }
    }
}
