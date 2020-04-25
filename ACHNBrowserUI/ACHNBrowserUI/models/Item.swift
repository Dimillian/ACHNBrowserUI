//
//  Item.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct ItemResponse: Codable {
    let total: Int
    let results: [Item]
}

struct Item: Codable, Equatable, Identifiable {
    var id: String { name }
    
    let name: String
    let image: String?
    let filename: String?
    
    var itemImage: String? {
        if let filename = filename {
            return filename
        } else if let image = image, !image.hasPrefix("https://storage") {
            return image
        }
        return nil
    }
    
    let obtainedFrom: String?
    let dIY: Bool?
    let customize: Bool?
    
    let variants: [Variant]?
    
    let category: String
    
    var appCategory: Category {
        if category == "Fish - North" || category == "Fish - South" {
            return .fish
        } else if category == "Bugs - North" || category == "Buhs - South" {
            return .bugs
        }
        return Category(rawValue: category.lowercased())!
    }
        
    let materials: [Material]?
    
    let buy: Int?
    let sell: Int?
    
    let weather: String?
    let shadow: String?
    let rarity: String?
    let activeMonthsNorth: [Int]?
    let activeMonthsSouth: [Int]?
    let activeTimes: [[String: Int]]?
    let set: String?
    let tag: String?
}

// MARK: - Calendar
extension Item {
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }()
    
    var activeMonths: [Int]? {
        var months = AppUserDefaults.hemisphere == .north ? activeMonthsNorth : activeMonthsSouth
        // Fix jan missing from API.
        if months?.count == 11 {
            months?.insert(0, at: 0)
        }
        return months
    }
    
    func isActive() -> Bool {
        let currentMonth = Int(Item.monthFormatter.string(from: Date()))!
        return activeMonths?.contains(currentMonth - 1) == true
           
    }
    
    func formattedTimes() -> String? {
        guard let activeTimes = activeTimes,
            let startTime = activeTimes.first?["startTime"],
            let endTime = activeTimes.first?["endTime"] else {
                return nil
        }
        if startTime == 0 && endTime == 0 {
            return "All day"
        }
        return "\(startTime) - \(endTime)h"
    }
}

// MARK: - Critters
extension Item {
    var isCritter: Bool {
        appCategory == .fish || appCategory == .bugs
    }
}

// MARK: - Array
extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] > b[keyPath: keyPath]
        }
    }
}

extension BidirectionalCollection where Element == Item {
    func filterActive() -> [Item] {
        self.filter({ $0.isActive() })
    }
}

let static_item = Item(name: "Acoustic guitar",
                       image: nil,
                       filename: "Test",
                       obtainedFrom: "Crafting",
                       dIY: true,
                       customize: true,
                       variants: nil,
                       category: "Housewares",
                       materials: nil,
                       buy: 200,
                       sell: 300,
                       weather: nil,
                       shadow: nil,
                       rarity: nil,
                       activeMonthsNorth: nil,
                       activeMonthsSouth: nil,
                       activeTimes: nil,
                       set: nil,
                       tag: "Instrument")
