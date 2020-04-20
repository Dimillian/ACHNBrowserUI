//
//  Material.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 11/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct Material: Codable, Equatable, Identifiable {
    var id: String { itemName }
    
    let itemName: String
    let count: Int
    
    var iconName: String {
        switch itemName {
        case "Softwood":
            return "icon-softwood"
        case "Wood":
            return "icon-wood"
        case "Hardwood":
            return "icon-hardwood"
        case "Tree branch":
            return "icon-branch"
        case "Iron nugget":
            return "icon-iron"
        case "Gold nugget":
            return "icon-gold"
        case "Clay":
            return "icon-clay"
        case "Clump of weed":
            return "icon-weed"
        case "Clump of weeds":
            return "icon-weed"
        case "Maple leaf":
            return "icon-mapple-leaf"
        case "Bamboo piece":
            return "icon-bamboo"
        case "Young spring bamboo":
            return "icon-bamboo-spring"
        default:
            return "icon-leaf"
        }
    }
}
