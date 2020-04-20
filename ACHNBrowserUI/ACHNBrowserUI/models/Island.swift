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
    let description: String?
    let queued: String
}

extension Island: Identifiable {
    var id: String {
        turnipCode
    }
}
