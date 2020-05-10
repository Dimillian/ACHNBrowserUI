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
    @Binding var animateCurves: Bool
    @Environment(\.presentationMode) var presentation
    @State private var chartWidth: CGFloat = 0

    var body: some View {
        VStack {
            TurnipsChartTopLegendView()
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    chart.frame(width: 600, height: 500)
                }
            }
        }
    }

    private var chart: some View {
        VStack(alignment: .custom, spacing: 10) {
            HStack {
                TurnipsChartVerticalLegend(predictions: predictions)
                    .frame(width: 30)
                curves
                    .alignmentGuide(.custom, computeValue: { $0[HorizontalAlignment.leading] })
                    .background(curvesGeometry)
            }
            TurnipsChartBottomLegendView(predictions: predictions)
                .frame(width: chartWidth, height: 50)
        }.padding()
    }

    private var curves: some View {
        ZStack {
            TurnipsChartGrid(predictions: predictions)
                .stroke()
                .opacity(0.5)
            TurnipsChartMinBuyPriceCurve(predictions: predictions)
                .stroke(style: StrokeStyle(dash: [Self.verticalLinesCount]))
                .foregroundColor(PredictionCurve.minBuyPrice.color)
                .saturation(3)
                .blendMode(.screen)
            TurnipsChartMinMaxCurves(predictions: predictions, animationStep: animateCurves ? 1 : 0.1)
                .foregroundColor(PredictionCurve.minMax.color)
                .opacity(0.25)
                .blendMode(.darken)
            TurnipsChartAverageCurve(predictions: predictions, animationStep: animateCurves ? 1 : 0)
                .stroke(lineWidth: 3)
                .foregroundColor(PredictionCurve.average.color)
                .saturation(5)
                .blendMode(.screen)
        }.animation(.spring())
    }

    private var curvesGeometry: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .onAppear(perform: { self.chartWidth = geometry.size.width })
        }
    }
}

private extension HorizontalAlignment {
    private struct CustomAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            return context[HorizontalAlignment.leading]
        }
    }

    static let custom = HorizontalAlignment(CustomAlignment.self)
}

struct TurnipsChartView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsChartView(
            predictions: predictions,
            animateCurves: .constant(true)
        )
    }

    static let predictions = TurnipPredictions(
        minBuyPrice: 83,
        averagePrices: averagePrices,
        minMax: minMax,
        averageProfits: averageProfits
    )

    static let averagePrices = [89, 85, 88, 104, 110, 111, 111, 111, 106, 98, 82, 77]

    static let minMax = [[38, 142], [33, 142], [29, 202], [24, 602], [19, 602], [14, 602], [9, 602], [29, 602], [24, 602], [19, 602], [14, 202], [9, 201]]

    static let averageProfits = [89, 85, 88, 104, 110, 111, 111, 111, 106, 98, 82, 77]
}
