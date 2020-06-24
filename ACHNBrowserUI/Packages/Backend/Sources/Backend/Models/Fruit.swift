//
//  Fruit.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 20/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public enum Fruit: String, Codable, CaseIterable {
    case apple
    case cherry
    case orange
    case peach
    case pear
    case coconut
}


public extension Fruit {
    var image: Image {
        Image(self.rawValue.capitalized)
    }
}
