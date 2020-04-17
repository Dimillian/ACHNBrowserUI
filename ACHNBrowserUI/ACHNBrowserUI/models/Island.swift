//
//  Island.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

struct Island: Codable {
    enum Commerce: String, Codable {
        case buying
        case neither
        case selling
    }
    
    enum Fruit: String, Codable {
        case apple
        case cherry
        case orange
        case peach
        case pear
    }
    
    enum Hemisphere: String, Codable {
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
    let islandDescription: String
    let queued: String
}
