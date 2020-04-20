//
//  AppUserDefault.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

struct AppUserDefaults {
    @UserDefault("island_name", defaultValue: "")
    static var islandName: String
    
    @UserDefaultEnum("hemisphere", defaultValue: Hemisphere.north)
    static var hemisphere: Hemisphere
    
    @UserDefaultEnum("fruit", defaultValue: Fruit.apple)
    static var fruit: Fruit
    
    @UserDefaultEnum("nook_shop", defaultValue: Infrastructure.NookShop.tent)
    static var nookShop: Infrastructure.NookShop
    
    @UserDefaultEnum("able_sisters", defaultValue: Infrastructure.AbleSisters.visiting)
    static var ableSisters: Infrastructure.AbleSisters
    
    @UserDefaultEnum("resident_service", defaultValue: Infrastructure.ResidentService.tent)
    static var residentService: Infrastructure.ResidentService
}

