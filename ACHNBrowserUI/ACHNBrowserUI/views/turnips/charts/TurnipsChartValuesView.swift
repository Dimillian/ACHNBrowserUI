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
    let data: [TurnipsChart.YAxis]
    let position: Int
    let padding: CGFloat = 16

    var body: some View {
        ZStack {
            Text("\(data[position].min.value)")
                .bold()
                .foregroundColor(.graphMinMax)
                .modifier(ValueModifier(backgroundColor: Color.acBackground))
                .position(data[position].min.position)
            Text("\(data[position].average.value)")
                .bold()
                .foregroundColor(.graphAverage)
                .saturation(5)
                .modifier(ValueModifier(backgroundColor: Color.acHeaderBackground))
                .position(data[position].average.position)
            Text("\(data[position].max.value)")
                .bold()
                .foregroundColor(.graphMinMax)
                .modifier(ValueModifier(backgroundColor: Color.acBackground))
                .position(data[position].max.position)
        }
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
                GeometryReader {
                    TurnipsChartValuesView(
                        data: TurnipsChartView_Previews.yAxisData(for: $0),
                        position: Int(self.position)
                    )
                }
                Slider(value: $position, in: 0...11)
            }
        }
    }
}
