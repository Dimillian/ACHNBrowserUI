//
//  Item.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public struct ItemResponse: Codable {
    let total: Int
    let results: [Item]
}

public struct Item: Codable, Equatable, Identifiable {
    static public func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.category == rhs.category
    }
    public var id: String { name }
    
    public let name: String
    public let image: String?
    public let filename: String?
    public let house: String?
    
    public var itemImage: String? {
        if let filename = filename {
            return filename
        } else if let image = image, !image.hasPrefix("https://storage") {
            return image
        }
        return nil
    }
    
    public let obtainedFrom: String?
    public let dIY: Bool?
    public let customize: Bool?
    
    public let variants: [Variant]?
    
    public let category: String
    
    public var appCategory: Category {
        if category == "Fish - North" || category == "Fish - South" {
            return .fish
        } else if category == "Bugs - North" || category == "Buhs - South" {
            return .bugs
        } else if category == "Nook Miles" {
            return .nookmiles
        }
        return Category(rawValue: category.lowercased())!
    }
        
    public let materials: [Material]?
    
    public let buy: Int?
    public let sell: Int?
    
    public let shadow: String?
    public let rarity: String?
    public let activeMonthsNorth: [Int]?
    public let activeMonthsSouth: [Int]?
    public let activeTimes: [[String: Int]]?
    public let set: String?
    public let tag: String?
    public let themes: [String]?
}

// MARK: - Calendar
public extension Item {
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }()
    
    var activeMonths: [Int]? {
        var months = AppUserDefaults.shared.hemisphere == .north ? activeMonthsNorth : activeMonthsSouth
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
    
    func isNewThisMonth() -> Bool {
        let currentMonth = Int(Item.monthFormatter.string(from: Date()))!
        return activeMonths?.contains(currentMonth - 2) == false
    }
    
    func leavingThisMonth() -> Bool {
        let currentMonth = Int(Item.monthFormatter.string(from: Date()))!
        return activeMonths?.contains(currentMonth) == false
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
public extension Item {
    var isCritter: Bool {
        appCategory == .fish || appCategory == .bugs
    }
}

// MARK: - Array
public extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] > b[keyPath: keyPath]
        }
    }
}

public let static_item = Item(name: "Acoustic guitar",
                       image: nil,
                       filename: "https://acnhcdn.com/latest/FtrIcon/FtrAcorsticguitar_Remake_0_0.png",
                       house: nil,
                       obtainedFrom: "Crafting",
                       dIY: true,
                       customize: true,
                       variants: nil,
                       category: "Housewares",
                       materials: nil,
                       buy: 200,
                       sell: 300,
                       shadow: nil,
                       rarity: nil,
                       activeMonthsNorth: nil,
                       activeMonthsSouth: nil,
                       activeTimes: nil,
                       set: nil,
                       tag: "Instrument",
                       themes: nil)
