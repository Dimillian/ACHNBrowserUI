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

public struct NewItemResponse: Codable {
    let total: Int
    let results: [ItemWrapper]
    
    public struct ItemWrapper: Codable {
        public let id: Int
        public let name: String
        public var content: Item
        public let variations: [Variant]?
    }
}

public struct ActiveMonth: Codable, Equatable {
    let activeTimes: [String]
}

public struct Item: Codable, Equatable, Identifiable, Hashable {
    static public func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.appCategory == rhs.appCategory
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(category)
    }
    
    public var id: String { name }
    public var internalID: Int?
    
    public var localizedName: String {
        if let id = internalID {
            return LocalizedItemService.shared.localizedNameFor(category: appCategory, itemId: id) ?? name
        }
        return name
    }
    
    public let name: String
    public let image: String?
    public let filename: String?
    public let house: String?
    public let itemImage: String?
    public var finalImage: String? {
        if let image = image, image.hasPrefix("https://acnhcdn") || image.hasPrefix("https://i.imgur")  {
            return image
        } else if let filename = filename {
            return filename
        }  else if let itemImage = itemImage {
            return itemImage
        }
        return nil
    }
    public let iconImage: String?
    public let furnitureImage: String?
    
    public let obtainedFrom: String?
    public let obtainedFromNew: [String]?
    public let sourceNotes: String?
    public let dIY: Bool?
    public let customize: Bool?
    
    public var variations: [Variant]?
    
    public let category: String
    
    public var appCategory: Category {
        Category(itemCategory: category)
    }
        
    public let materials: [Material]?
    
    public let buy: Int?
    public let sell: Int?
    
    public let shadow: String?
    public let activeMonths: [String: ActiveMonth]?
    public let set: String?
    public let tag: String?
    public let styles: [String]?
    public let themes: [String]?
    public let colors: [String]?
    
    public var metas: [String] {
        var metas: [String] = []
        if let tag = tag {
            metas.append(tag)
        }
        if let set = set {
            metas.append(set)
        }
        if let styles = styles {
            metas.append(contentsOf: styles)
        }
        if let themes = themes {
            metas.append(contentsOf: themes)
        }
        if let colors = colors {
            metas.append(contentsOf: colors)
        }
        return Array(Set(metas.map{ $0.capitalized })).filter({ $0.lowercased() != "none"}).sorted()
    }
}

// Formatter used for the start / end times of critters
fileprivate let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = is24Hour() ? "HH" : "ha"
    return formatter
}()

/// Determine if the device is set to 24 or 12 hour time
fileprivate func is24Hour() -> Bool {
    let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
    return dateFormat.firstIndex(of: "a") == nil
}

// MARK: - Calendar
public extension Item {
    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }()
    
    var activeMonthsCalendar: [Int]? {
        let isSouth = AppUserDefaults.shared.hemisphere == .south
        if var keys = activeMonths?.keys.compactMap({ Int($0) }) {
            if isSouth {
                keys = keys.map{ ($0 + 6) % 12 }
            }
            return keys
        }
        return nil
    }
    
    func isActive() -> Bool {
        let currentMonth = Int(Item.monthFormatter.string(from: Date()))!
        return activeMonthsCalendar?.contains(currentMonth - 1) == true
           
    }
    
    func isNewThisMonth() -> Bool {
        let currentMonth = Int(Item.monthFormatter.string(from: Date()))!
        return activeMonthsCalendar?.contains(currentMonth - 2) == false
    }
    
    func leavingThisMonth() -> Bool {
        let currentMonth = Int(Item.monthFormatter.string(from: Date()))!
        return activeMonthsCalendar?.contains(currentMonth) == false
    }
    
    func formattedTimes() -> String? {
        guard let activeTimes = activeMonths?.first?.value.activeTimes,
            let startTime = activeTimes.first,
            let endTime = activeTimes.last else {
                return nil
        }
        if Int(startTime) == 0 && Int(endTime) == 0 {
            return NSLocalizedString("All day", comment: "")
        }
        
        var startHourInt = 0
        var endHourInt = 0
        if let hour = Int(startTime.prefix(1)) {
            startHourInt = hour
            if startTime.suffix(2)  == "pm" {
                startHourInt += 12
            }
        }
        
        if let hour = Int(endTime.prefix(1)) {
            endHourInt = hour
            if endTime.suffix(2) == "pm" {
                endHourInt += 12
            }
        }
        
        let startDate = DateComponents(calendar: .current, hour: startHourInt).date!
        let endDate = DateComponents(calendar: .current, hour: endHourInt).date!
        
        let startHour = formatter.string(from: startDate)
        let endHour = formatter.string(from: endDate)
        
        return "\(startHour) - \(endHour)\(is24Hour() ? "h" : "")"
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
                       itemImage: nil,
                       iconImage: nil,
                       furnitureImage: nil,
                       obtainedFrom: "Crafting",
                       obtainedFromNew: ["Crafting"],
                       sourceNotes: "From somewhere",
                       dIY: true,
                       customize: true,
                       variations: nil,
                       category: "Housewares",
                       materials: nil,
                       buy: 200,
                       sell: 300,
                       shadow: nil,
                       activeMonths: nil,
                       set: nil,
                       tag: "Instrument",
                       styles: nil,
                       themes: nil,
                       colors: nil)
