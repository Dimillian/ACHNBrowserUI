//
//  UIState.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 02/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

class UIState: ObservableObject {
    enum Tab: Int {
        case dashboard = 0
        case items = 1
        case villagers = 3
        case collection = 4
        case turnips = 2
    }
    
    init() {
        self.selectedTab = Tab.dashboard
    }

    var selectedTab: Tab {
        didSet {
            objectWillChange.send()
        }
    }

    var selectedTabIndex: Int {
        get {
            return selectedTab.rawValue
        }
        set {
            self.selectedTab = Tab(rawValue: newValue)!
        }
    }
}
