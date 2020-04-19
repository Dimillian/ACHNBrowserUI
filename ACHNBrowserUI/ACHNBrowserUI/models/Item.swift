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
    let obtainedFrom: String?
    let dIY: Bool?
    let customize: Bool?
    
    let variants: [String]?
    
    let category: String
    var appCategory: Categories? {
        Categories(rawValue: category.lowercased().replacingOccurrences(of: " ", with: ""))
    }
    
    let materials: [Material]?
    
    let buy: Int?
    let sell: Int?
    
    let starTime: CritterTimeContainer?
    let endTime: CritterTimeContainer?
    
    let set: String?
    
    let jan: Bool?
    let feb: Bool?
    let mar: Bool?
    let apr: Bool?
    let may: Bool?
    let jun: Bool?
    let jul: Bool?
    let aug: Bool?
    let sep: Bool?
    let oct: Bool?
    let nov: Bool?
    let dec: Bool?
    
    init(name: String, image: String, obtainedFrom: String, dIY: Bool,
         customize: Bool, variants: [String], category: String, buy: Int, sell: Int, set: String) {
        self.name = name
        self.image = image
        self.obtainedFrom = obtainedFrom
        self.dIY = dIY
        self.customize = customize
        self.variants = variants
        self.category = category
        self.buy = buy
        self.sell = sell
        self.set = set
        
        self.materials = nil
        
        self.starTime = nil
        self.endTime = nil
        
        self.jan = false
        self.feb = false
        self.mar = false
        self.apr = false
        self.may = false
        self.jun = false
        self.jul = false
        self.aug = false
        self.sep = false
        self.oct = false
        self.nov = false
        self.dec = false
    }
}

enum CritterTimeContainer: Codable, Equatable {
    case float(Float)
    case string(String)
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .float(let v): try container.encode(v)
        case .string(let v): try container.encode(v)
        }
    }
    
    init(from decoder: Decoder) throws {
        let value = try decoder.singleValueContainer()
        
        if let v = try? value.decode(Float.self) {
            self = .float(v)
            return
        } else if let v = try? value.decode(String.self) {
            self = .string(v)
            return
        }
        
        throw ParseError.notRecognizedType(value)
    }
    
    enum ParseError: Error {
        case notRecognizedType(Any)
    }
}

extension Item {
    fileprivate static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        return formatter
    }()
    
    func isActive() -> Bool {
        let months = [jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec]
        let currentMonth = Int(Item.formatter.string(from: Date()))!
        return months[currentMonth - 1] == true
    }
}

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
                       image: "3FX566U",
                       obtainedFrom: "Crafting",
                       dIY: true,
                       customize: true,
                       variants: ["3FX566U", "dob8IS9", "fJWXEXw", "CrJ1ozg", "LJROUEd", ""],
                       category: "Housewares",
                       buy: 200,
                       sell: 300,
                       set: "Instrument")
