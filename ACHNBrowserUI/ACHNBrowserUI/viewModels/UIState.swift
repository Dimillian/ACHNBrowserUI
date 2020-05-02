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
        case dashboard, items, villagers, collection, turnips
    }
    
    @Published var selectedTab = Tab.dashboard
}
