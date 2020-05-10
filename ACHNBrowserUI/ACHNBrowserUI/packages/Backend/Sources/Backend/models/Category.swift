//
//  Category.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public enum Category: String, CaseIterable {
    case housewares, miscellaneous
    case wallMounted = "wall-mounted"
    case wallpapers, floors, rugs, photos, posters, fencing, tools
    case tops, bottoms, dresses, headwear, accessories, socks, shoes, bags
    case umbrellas, music, recipes, construction, nookmiles, other
    case art, bugs, fish, fossils
    
    public func label() -> LocalizedStringKey {
        return LocalizedStringKey(self.rawValue)
    }
    
    public func iconName() -> String {
        switch self {
        case .housewares, .miscellaneous, .wallMounted, .photos, .posters, .art:
            return "icon-leaf"
        case .recipes:
            return "icon-recipe"
        case .wallpapers:
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
        case .music:
            return "icon-song"
        case .fossils:
            return "icon-fossil"
        case .construction:
            return "icon-helmet"
        case .nookmiles:
            return "icon-miles"
        case .other:
            return "icon-leaf"
        case .bugs:
            return "icon-insect"
        case .fish:
            return "icon-fish"
        case .tools:
            return "icon-tool"
        case .dresses:
            return "icon-top"
        case .shoes:
            return "icon-shoes"
        }
    }
    
    public static func furnitures() -> [Category] {
        [.housewares, .miscellaneous, .wallMounted, .art]
    }
        
    public static func villagerFurnitures() -> [Category] {
        [.housewares, .miscellaneous, .wallMounted, .art,
         .wallpapers, .floors, .rugs, .photos, .music]
    }
    
    public static func items() -> [Category] {
        [.housewares, .miscellaneous, .wallMounted, .art,
         .wallpapers, .floors, .rugs, .photos, .fencing, .tools, .music, .nookmiles,
         .recipes, .construction, .other]
    }
    
    public static func wardrobe() -> [Category] {
        [.tops, .bottoms, .dresses, .headwear,
         .accessories, .socks, .shoes, .bags, .umbrellas]
    }
    
    public static func nature() -> [Category] {
        return [.fish, .bugs, .fossils]
    }
    
    public static func icons() -> [Category] {
        return  [.housewares, .recipes, .floors, .rugs, .wallpapers,
                .fencing, .music, .tools, .nookmiles, .construction, .tops,
                 .bottoms, .dresses, .headwear, .accessories, .socks, .bags, .umbrellas,
                 .fish, .bugs, .fossils]
    }
}
