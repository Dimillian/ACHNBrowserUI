//
//  Categories.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

enum Categories: String, CaseIterable {
    case housewares, miscellaneous
    case wallMounted = "wall-mounted"
    case wallpaper, floors, rugs, photos, posters, fencing, tools
    case tops, bottoms, dresses, headwear, accessories, socks, shoes, bags
    case umbrellas, songs, recipes, fossils, construction, nookmiles, other
    case bugsNorth = "bugs-north"
    case bugsSouth = "bugs-south"
    case fishesNorth = "fish-north"
    case fishesSouth = "fish-south"
    
    func iconName() -> String {
        switch self {
        case .housewares, .miscellaneous, .wallMounted, .photos, .posters:
            return "icon-leaf"
        case .recipes:
            return "icon-recipe"
        case .wallpaper:
            return "icon-wallpaper"
        case .floors:
            return "icon-floor"
        case .rugs:
            return "icon-rug"
        case .fencing:
            return "icon-fence"
        case .tops:
            return "icon-top"
        case .bottoms:
            return "icon-pant"
        case .accessories:
            return "icon-glasses"
        case .headwear:
            return "icon-helm"
        case .socks:
            return "icon-socks"
        case .umbrellas:
            return "icon-umbrella"
        case .bags:
            return "icon-bag"
        case .songs:
            return "icon-song"
        case .fossils:
            return "icon-fossil"
        case .construction:
            return "icon-helmet"
        case .nookmiles:
            return "icon-miles"
        case .other:
            return "icon-leaf"
        case .bugsNorth, .bugsSouth:
            return "icon-insect"
        case .fishesNorth, .fishesSouth:
            return "icon-fish"
        case .tools:
            return "icon-tool"
        case .dresses:
            return "icon-top"
        case .shoes:
            return "icon-shoes"
        }
    }
    
    static func items() -> [Categories] {
        return [.housewares, .miscellaneous, .wallMounted,
                .wallpaper, .floors, .rugs, .photos, .fencing, .tools, .songs, .nookmiles,
                .recipes, .construction, .other]
    }
    
    static func wardrobe() -> [Categories] {
        return [.tops, .bottoms, .dresses, .headwear,
                .accessories, .socks, .shoes, .bags, .umbrellas]
    }
    
    static func nature() -> [Categories] {
        return [.bugsNorth, .bugsSouth, .fishesNorth, .fishesSouth, .fossils]
    }
}
