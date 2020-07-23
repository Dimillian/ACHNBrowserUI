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
    case tops, bottoms, headwear, accessories, socks, shoes, bags
    case dressup = "Dress-Up"
    case clothingOther = "Clothing Other"
    case umbrellas, music, recipes, construction, nookmiles, other
    case art, bugs, fish, fossils
    case seaCreatures = "Sea Creatures"
    
    public init(itemCategory: String) {
        if itemCategory == "Fish - North" || itemCategory == "Fish - South" {
            self = .fish
            return
        } else if itemCategory == "Bugs - North" || itemCategory == "Bugs - South" || itemCategory == "Insects" {
            self = .bugs
            return
        } else if itemCategory == "Dress-Up" {
            self = .dressup
            return
        } else if itemCategory == "Clothing Other" {
            self = .clothingOther
            return
        } else if itemCategory == "Sea Creatures" {
            self = .seaCreatures
            return
        } else if itemCategory == "Wallpaper" {
            self = .wallpapers
            return
        }
        self = Category(rawValue: itemCategory.lowercased()) ?? .other
    }
    
    public func label() -> LocalizedStringKey {
        return LocalizedStringKey(self.rawValue)
    }
    
    public func iconName() -> String {
        switch self {
        case .miscellaneous:
            return "icon-leaf"
        case .posters:
            return "icon-posters"
        case .wallMounted:
            return "icon-wallmounted"
        case .housewares:
            return "icon-housewares"
        case .photos:
            return "icon-photos"
        case .art:
            return "icon-board"
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
            return "Ins13"
        case .fish:
            return "Fish6"
        case .tools:
            return "icon-tool"
        case .dressup:
            return "icon-top"
        case .shoes:
            return "icon-shoes"
        case .clothingOther:
            return "icon-wetsuit"
        case .seaCreatures:
            return "div25"
        }
    }
    
    public static func dataFilename(category: Category) -> String? {
        if APIFurnitures().contains(category) {
            return "furnitures"
        } else if APIClothing().contains(category) {
            return "clothing"
        } else if APIIslandDevelopment().contains(category) {
            return "islanddevelopment"
        } else if category == .recipes ||
            category == .nookmiles ||
            category == .construction ||
            category == .fish ||
            category == .bugs ||
            category == .fossils ||
            category == .floors ||
            category == .rugs ||
            category == .wallpapers {
            return category.rawValue
        } else if category == .seaCreatures {
            return "divefish"
        }
        return nil
    }
    
    public static func APIFurnitures() -> [Category] {
        [.housewares, .miscellaneous, .wallMounted, .art]
    }
    
    public static func APIClothing() -> [Category] {
        [.accessories, .headwear, .tops, .bottoms, .dressup, .socks, .shoes, .bags, .clothingOther]
    }
    
    public static func APIIslandDevelopment() -> [Category] {
        [.construction, .other, .fencing]
    }
    
    public static func collectionCategories() -> [Category] {
        var base: [Category]  = [.fish, .bugs, .seaCreatures, .fossils, .art]
        var items = Self.items()
        items.removeAll(where: { $0 == .art })
        base.append(contentsOf: items)
        base.append(contentsOf: Self.wardrobe())
        return base
    }
        
    public static func villagerFurnitures() -> [Category] {
        [.housewares, .miscellaneous, .wallMounted, .art,
         .wallpapers, .floors, .rugs, .photos, .music]
    }
    
    public static func items() -> [Category] {
        [.housewares, .miscellaneous, .wallMounted, .art,
         .wallpapers, .floors, .rugs, .photos, .posters, .fencing, .tools, .music, .nookmiles,
         .recipes, .construction, .other]
    }
    
    public static func wardrobe() -> [Category] {
        [.tops, .bottoms, .dressup, .headwear,
         .accessories, .socks, .shoes, .bags, .umbrellas, .clothingOther]
    }
    
    public static func nature() -> [Category] {
        [.fish, .seaCreatures, .bugs, .fossils]
    }
    
    public static func icons() -> [Category] {
        [.housewares, .recipes, .floors, .rugs, .wallpapers, .posters,
                .fencing, .music, .tools, .nookmiles, .construction, .tops,
                .bottoms, .dressup, .clothingOther, .headwear, .accessories, .socks, .bags, .umbrellas,
                 .fish, .bugs, .fossils]
    }
    
    public static func villagersGifts() -> [Category] {
        [.tops, .dressup, .headwear, .accessories]
    }
}
