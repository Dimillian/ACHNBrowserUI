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
    
    let set: String?
}

extension Sequence {
    func sorted<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        return sorted { a, b in
            return a[keyPath: keyPath] > b[keyPath: keyPath]
        }
    }
}

let static_item = Item(name: "Acoustic guitar",
                       image: "3FX566U",
                       obtainedFrom: "Crafting",
                       dIY: true,
                       customize: true,
                       variants: ["3FX566U", "dob8IS9", "fJWXEXw", "CrJ1ozg", "LJROUEd", ""],
                       category: "Housewares",
                       materials: nil,
                       buy: 200,
                       sell: 300,
                       set: "Instrument")
