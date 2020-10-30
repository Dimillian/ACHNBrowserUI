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
    @Binding var animateCurves: Bool
    @Environment(\.presentationMode) var presentation
    @State private var chartSize: CGSize?
    @State private var verticalLegendWidth: CGFloat?
    @State private var bottomLegendHeight: CGFloat?
    @State private var positionPressed: Int?

    var body: some View {
        VStack {
            TurnipsChartTopLegendView()
            HStack(alignment: .top) {
                TurnipsChartVerticalLegend(data: yAxisData)
                    .frame(width: verticalLegendWidth, height: chartSize?.height)
                    .padding(.top)
                ScrollView(.horizontal, showsIndicators: false) {
                    chart.frame(width: 600, height: 500)
                }
            }
        }
        .storeValue(from: ChartSizePreferenceKey.self, in: $chartSize)
        .storeValue(from: TurnipsChartBottomLegendView.HeightPreferenceKey.self, in: $bottomLegendHeight)
        .storeValue(from: TurnipsChartVerticalLegend.WidthPreferenceKey.self, in: $verticalLegendWidth)
    }
    
    private var chart: some View {
        VStack(spacing: 10) {
            curves
            TurnipsChartBottomLegendView(data: yAxisData, positionPress: positionPress)
                .frame(width: chartSize?.width, height: bottomLegendHeight)
        }
        .padding()
    }
    
    private var curves: some View {
        ZStack(alignment: .leading) {
            TurnipsChartGridInteractiveVerticalLines(data: yAxisData, positionPress: positionPress)
            TurnipsChartGrid(data: yAxisData)
                .stroke()
                .opacity(0.5)
                .propagate({ $0.size }, using: ChartSizePreferenceKey.self)
            TurnipsChartMinBuyPriceCurve(data: yAxisData)
                .stroke(style: StrokeStyle(dash: [Self.verticalLinesCount]))
                .foregroundColor(.graphMinimum)
                .saturation(3)
                .blendMode(.screen)
            TurnipsChartMinMaxCurves(data: yAxisData, animationStep: animateCurves ? 1 : 0.1)
                .foregroundColor(.graphMinMax)
                .opacity(0.25)
                .blendMode(.darken)
            TurnipsChartAverageCurve(data: yAxisData, animationStep: animateCurves ? 1 : 0)
                .stroke(lineWidth: 3)
                .foregroundColor(.graphAverage)
                .saturation(5)
                .blendMode(.screen)
            positionPressed.map {
                TurnipsChartValuesView(data: yAxisData, position: $0)
            }
        }.animation(.spring())
    }

    private func positionPress(_ position: Int) {
        positionPressed = position
    }

    private var yAxisData: [TurnipsChart.YAxis] {
        TurnipsChart.data(
            for: predictions,
            size: chartSize ?? .zero
        )
    }
}

extension TurnipsChartView {
    private struct ChartSizePreferenceKey: PreferenceKey {
        static var defaultValue: CGSize?
        static func reduce(value: inout CGSize?, nextValue: () -> CGSize?) {
            if let newValue = nextValue() { value = newValue }
        }
    }

    private struct ChartValuesPreferenceKey: PreferenceKey {
        typealias Value = [Int: TurnipsChart.YAxis]
        static var defaultValue: Value = [:]

        static func reduce(value: inout Value, nextValue: () -> Value) {
            value.merge(nextValue()) { $1 }
        }
    }
}

struct TurnipsChartView_Previews: PreviewProvider {
    static var previews: some View {
        TurnipsChartView(
            predictions: predictions,
            animateCurves: .constant(true)
        )
    }

    static func yAxisData(for geometry: GeometryProxy) -> [TurnipsChart.YAxis] {
        TurnipsChart.data(for: predictions, size: geometry.size)
    }

    static let predictions = TurnipPredictions(
        minBuyPrice: 83,
        averagePrices: averagePrices,
        minMax: minMax,
        averageProfits: averageProfits,
        currentDate: Date()
    )

    static let averagePrices = [89, 85, 88, 104, 110, 111, 111, 111, 106, 98, 82, 77]

    static let minMax = [[38, 142], [33, 142], [29, 202], [24, 602], [19, 602], [14, 602], [9, 602], [29, 602], [24, 602], [19, 602], [14, 202], [9, 201]]

    static let averageProfits = [89, 85, 88, 104, 110, 111, 111, 111, 106, 98, 82, 77]
}
