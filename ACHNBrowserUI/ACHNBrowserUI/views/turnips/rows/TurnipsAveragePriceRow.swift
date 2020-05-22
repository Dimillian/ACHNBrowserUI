//
//  TurnipsAveragePriceRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 29/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TurnipsAveragePriceRow: View {
    let label: String
    let prices: [Int]
    let minMaxPrices: [[Int]]

    var body: some View {
        HStack {
            Text(LocalizedStringKey(label))
                .font(.body)
                .foregroundColor(.acText)
            Spacer()
            Text("\(prices.first!)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color(meridian: .am))
            Spacer()
            Text("\(prices.last!)")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color(meridian: .pm))
        }
    }
}

extension TurnipsAveragePriceRow: TurnipsPriceRow {
    enum Meridian { case am, pm }

    var averagePrices: [Int] { prices }

    func color(meridian: Meridian) -> Color {
        if isEntered(meridian: meridian) {
            return .acText
        } else if let price = meridian == .am ? prices.first : prices.last {
            return color(price: price)
        } else {
            return .clear
        }
    }
}

struct TurnipsAveragePriceRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TurnipsAveragePriceRow(label: "Mon", prices: [90, 95], minMaxPrices: [[90, 90], [81, 141]])
                TurnipsAveragePriceRow(label: "Mon", prices: [40, 600], minMaxPrices: [[40, 81], [250, 600]])
            }
        }
    }
}
