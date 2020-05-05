//
//  Island.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public struct Island: Decodable {
    public let name: String
    public let fruit: Fruit
    public let turnipPrice: Int
    public let maxQueue: Int
    public let turnipCode: String
    public let hemisphere: Hemisphere
    public let watchlist: Int
    public let islandTime: String
    public let creationTime: String
    public let description: String?
    public let queued: String
}

extension Island: Identifiable {
    public var id: String {
        turnipCode
    }
}
