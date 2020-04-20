//
//  Infrastucture.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 20/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

struct Infrastructure {
    enum NookShop: String, CaseIterable {
        case tent = "Tent"
        case crany = "Nook's Cranny"
        case upraded = "Nook's Cranny upgraded"
    }
    
    enum AbleSisters: String, CaseIterable {
        case visiting, shop
    }
    
    enum ResidentService: String, CaseIterable {
        case tent, building
    }
}
