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
    let data: [TurnipsChart.YAxis]
    var animationStep: CGFloat = 1

    var animatableData: CGFloat {
        get { animationStep }
        set { animationStep = newValue }
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let animationYTranslation = rect.maxY - rect.maxY * animatableData
        let animationTransform = CGAffineTransform.identity
            .translatedBy(x: 0, y: animationYTranslation)
            .scaledBy(x: 1, y: animatableData)

        let minPoints: [CGPoint] = data
            .map(\.min.position)
            .map({ $0.applying(animationTransform) })
        path.addHermiteCurvedLines(points: minPoints)

        let maxPoints: [CGPoint] = data
            .map(\.max.position)
            .reversed()
            .map({ $0.applying(animationTransform) })
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
                GeometryReader {
                    TurnipsChartMinMaxCurves(
                        data: TurnipsChartView_Previews.yAxisData(for: $0),
                        animationStep: self.animationStep
                    )
                        .foregroundColor(.graphMinMax)
                        .opacity(0.25)
                        .blendMode(.darken)
                }
                Slider(value: $animationStep, in: 0.1...1)
            }
        }
    }
}
