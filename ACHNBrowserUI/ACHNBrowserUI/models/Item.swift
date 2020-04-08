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
    
    let buy: Int?
    let sell: Int?
    
    let set: String?
}
