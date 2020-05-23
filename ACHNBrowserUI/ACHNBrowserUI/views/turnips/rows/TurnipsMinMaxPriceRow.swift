//
//  TurnipsMinMaxPriceRow.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 22/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TurnipsMinMaxPriceRow: View {
    let label: String
    let prices: [[Int]]
    let averagePrices: [Int]

    typealias Meridian = TurnipsAveragePriceRow.Meridian

    var body: some View {
        HStack {
            Text(LocalizedStringKey(label))
                .font(.body)
                .foregroundColor(.acText)
            Spacer()
            Text(amMinMaxPrices)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color(meridian: .am))
            Spacer()
            Text(pmMinMaxPrices)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color(meridian: .pm))
        }
    }
}

extension TurnipsMinMaxPriceRow: TurnipsPriceRow {
    var minMaxPrices: [[Int]] { prices }

    private func color(meridian: Meridian) -> Color {
        let amAveragedPrices = prices.first?.average
        let pmAveragedPrices = prices.last?.average
        guard let averagedPrice = meridian == .am ? amAveragedPrices : pmAveragedPrices else {
            return .clear
        }
        return isEntered(meridian: meridian) ? .acText : color(price: Int(averagedPrice))
    }

    private var amMinMaxPrices: String {
        guard let min = prices.first?.first,
            let max = prices.first?.last else {
                return ""
        }
        if isEntered(meridian: .am) {
            return "\(min)"
        } else {
            return "\(min) - \(max)"
        }
    }

    private var pmMinMaxPrices: String {
        guard let min = prices.last?.first,
            let max = prices.last?.last else {
                return ""
        }
        if isEntered(meridian: .pm) {
            return "\(min)"
        } else {
            return "\(min) - \(max)"
        }
    }
}

struct TurnipsMinMaxPriceRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TurnipsMinMaxPriceRow(label: "Mon", prices: [[90, 90], [81, 141]], averagePrices: [90, 95])
                TurnipsMinMaxPriceRow(label: "Mon", prices: [[60, 90], [81, 81]], averagePrices: [70, 81])
                TurnipsMinMaxPriceRow(label: "Mon", prices: [[40, 81], [250, 600]], averagePrices: [40, 600])
            }
        }
    }
}
