//
//  SettingsViewModel.swift
//  ACHNBrowserUI
//
//  Created by Rohan Ramakrishnan on 6/14/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import Backend
class SettingsViewModel: ObservableObject {
    
    @Published var shopNotificationsEnabled: Bool {
        didSet {
            AppUserDefaults.shared.shopNotificationsEnabled = shopNotificationsEnabled
        }
    }
    
    init() {
        
    }
}
