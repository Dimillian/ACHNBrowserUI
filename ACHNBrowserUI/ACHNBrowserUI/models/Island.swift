//
//  Island.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct Island: Decodable {
    enum Commerce: String, Decodable {
        case buying
        case neither
        case selling
    }
    
    enum Fruit: String, Decodable {
        case apple
        case cherry
        case orange
        case peach
        case pear
    }
    
    enum Hemisphere: String, Decodable {
        case north
        case south
    }
    
    let name: String
    let fruit: Fruit
    let turnipPrice: Int
    let maxQueue: Int
    let turnipCode: String
    let hemisphere: Hemisphere
    let watchlist: Int
    let commerce: Commerce
    let islandTime: String
    let creationTime: String
    let islandDescription: String?
    let queued: String
}

extension Island: Identifiable {
    var id: String {
        turnipCode
    }
}

extension Island.Fruit {
    var image: Image {
        Image(self.rawValue.capitalized)
    }
}
