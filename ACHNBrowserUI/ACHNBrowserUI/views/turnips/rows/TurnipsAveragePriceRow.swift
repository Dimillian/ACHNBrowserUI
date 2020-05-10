//
//  TurnipsAveragePriceROw.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 29/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TurnipsAveragePriceRow: View {
    let label: String
    let prices: [Int]?
    let minMaxPrices: [[Int]]?
    
    init(label: String, prices: [Int]) {
        self.label = label
        self.prices = prices
        self.minMaxPrices = nil
    }
    
    init(label: String, minMaxPrices: [[Int]]) {
        self.label = label
        self.prices = nil
        self.minMaxPrices = minMaxPrices
    }
    
    private func color(price: Int) -> Color {
        if price <= 90 {
            return .red
        } else if price >= 150 {
            return .acTabBarBackground
        } else {
            return .acSecondaryText
        }
    }
    
    private func color(prices: [Int]) -> Color {
        color(price: Int(prices.average))
    }
    
    var body: some View {
        HStack {
            Text(LocalizedStringKey(label))
                .font(.body)
                .foregroundColor(.acText)
            Spacer()
            if prices != nil {
                Text("\(prices!.first!)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color(price: prices!.first!))
                Spacer()
                Text("\(prices!.last!)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color(price: prices!.last!))
            } else if minMaxPrices != nil {
                Text("\(minMaxPrices!.first!.first!) - \(minMaxPrices!.first!.last!)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color(prices: minMaxPrices!.first!))
                Spacer()
                Text("\(minMaxPrices!.last!.first!) - \(minMaxPrices!.last!.last!)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(color(prices: minMaxPrices!.last!))
            }
        }
    }
}

struct TurnipsAveragePriceRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TurnipsAveragePriceRow(label: "Mon", prices: [90, 95])
                TurnipsAveragePriceRow(label: "Mon", prices: [40, 600])
            }
        }
    }
}
