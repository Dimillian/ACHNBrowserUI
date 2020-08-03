//
//  AppUserDefault.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

public class AppUserDefaults: ObservableObject {
    public static let shared = AppUserDefaults()
    
    @AppStorage("island_name")
    public var islandName = ""
    
    @AppStorage("game_name")
    public var inGameName = ""
    
    @AppStorage("dodo_code")
    public var dodoCode = ""
    
    @UserDefaultEnum("hemisphere", defaultValue: Hemisphere.north)
    public var hemisphere: Hemisphere {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefaultEnum("fruit", defaultValue: Fruit.apple)
    public var fruit: Fruit {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefaultEnum("nook_shop", defaultValue: Infrastructure.NookShop.tent)
    public var nookShop: Infrastructure.NookShop {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefaultEnum("able_sisters", defaultValue: Infrastructure.AbleSisters.visiting)
    public var ableSisters: Infrastructure.AbleSisters {
        willSet {
            objectWillChange.send()
        }
    }
    
    @UserDefaultEnum("resident_service", defaultValue: Infrastructure.ResidentService.tent)
    public var residentService: Infrastructure.ResidentService {
        willSet {
            objectWillChange.send()
        }
    }
    
    @AppStorage("is_subscribed")
    public var isSubscribed: Bool = false
    
    @UserDefaultCodable("today_sections", defaultValue: TodaySection.defaultSectionList)
    public var todaySectionList: [TodaySection] {
        willSet {
            objectWillChange.send()
        }
    }

    @AppStorage("spotlight_index_version")
    public var spotlightIndexVersion =  ""
    
    @AppStorage("number_of_launch")
    public var numberOfLaunch = 0
    
    @AppStorage("dodo_notifications")
    public var dodoNotifications = false
    
    @AppStorage("news_notifications")
    public var newsNotifications = true

    @AppStorage("dream_notifications")
    public var dreamNotifications = false
}

