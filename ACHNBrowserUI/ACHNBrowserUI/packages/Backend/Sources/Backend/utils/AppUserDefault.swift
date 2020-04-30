//
//  AppUserDefault.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

public struct AppUserDefaults {
    @UserDefault("island_name", defaultValue: "")
    public static var islandName: String
    
    @UserDefaultEnum("hemisphere", defaultValue: Hemisphere.north)
    public static var hemisphere: Hemisphere
    
    @UserDefaultEnum("fruit", defaultValue: Fruit.apple)
    public static var fruit: Fruit
    
    @UserDefaultEnum("nook_shop", defaultValue: Infrastructure.NookShop.tent)
    public static var nookShop: Infrastructure.NookShop
    
    @UserDefaultEnum("able_sisters", defaultValue: Infrastructure.AbleSisters.visiting)
    public static var ableSisters: Infrastructure.AbleSisters
    
    @UserDefaultEnum("resident_service", defaultValue: Infrastructure.ResidentService.tent)
    public static var residentService: Infrastructure.ResidentService
}

