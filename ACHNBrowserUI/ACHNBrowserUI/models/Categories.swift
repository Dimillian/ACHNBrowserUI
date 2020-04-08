//
//  Categories.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

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
