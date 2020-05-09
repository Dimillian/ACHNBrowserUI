//
//  TurnipsChartTopLegendView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 05/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TurnipsChartTopLegendView: View {
    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 4) {
                Rectangle().fill(Color.graphAverage).frame(width: 40, height: 20)
                Text("Average").font(.footnote).foregroundColor(.acText)
            }
            HStack(spacing: 4) {
                Rectangle().fill(Color.graphMinMax).frame(width: 40, height: 20)
                Text("MinMax").font(.footnote).foregroundColor(.acText)
            }
            HStack(spacing: 4) {
                Rectangle().fill(Color.graphMinimum).frame(width: 40, height: 20)
                Text("Minimum").font(.footnote).foregroundColor(.acText)
            }
        }
    }
}
