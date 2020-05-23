//
//  TurnipsPriceRow.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 22/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

protocol TurnipsPriceRow {
    var label: String { get }
    var averagePrices: [Int] { get }
    var minMaxPrices: [[Int]] { get }
}

extension TurnipsPriceRow {
    typealias Meridian = TurnipsAveragePriceRow.Meridian

    func color(price: Int) -> Color {
        if price <= 90 {
            return .red
        } else if price >= 150 {
            return .acTabBarBackground
        } else {
            return .acSecondaryText
        }
    }

    func isEntered(meridian: Meridian) -> Bool {
        switch meridian {
        case .am:
            guard let price = averagePrices.first,
                let minMaxFirst = minMaxPrices.first?.first,
                let minMaxSecond = minMaxPrices.first?.last else {
                    return false
            }
            return price == minMaxFirst && price == minMaxSecond && minMaxFirst == minMaxSecond
        case .pm:
            guard let price = averagePrices.last,
                let minMaxFirst = minMaxPrices.last?.first,
                let minMaxSecond = minMaxPrices.last?.last else {
                    return false
            }
            return price == minMaxFirst && price == minMaxSecond && minMaxFirst == minMaxSecond
        }
    }
}
