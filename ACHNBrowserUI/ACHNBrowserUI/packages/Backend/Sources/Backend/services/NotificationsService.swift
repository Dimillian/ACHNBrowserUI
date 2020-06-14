//
//  File.swift
//  
//
//  Created by Rohan Ramakrishnan on 6/14/20.
//

import Foundation

public class SettingsService: ObservableObject {
    public static let shared = SettingsService()
    
    public var shopSettingsEnabled: Bool = false {
        didSet {
            NotificationManager.shared.removeShopNotifications()
            if shopSettingsEnabled {
                registerShopNotifications()
            }
        }
    }
    public var eventSettingsEnabled: Bool = false {
        didSet {
            NotificationManager.shared.removeShopNotifications()
            if eventSettingsEnabled {
                // TODO function for registering events
            }
        }
    }
    
    private init() {
        registerShopNotifications()
    }
    
    private func registerShopNotifications() {
        NotificationManager.shared.registerSettingsNotifications(subtitle: "Nook’s Cranny store is open", hour: 8, minute: 0, isRepeated: true)
        NotificationManager.shared.registerSettingsNotifications(subtitle: "Nook’s Cranny store is closing in 1h", hour: 21, minute: 0, isRepeated: true)
        NotificationManager.shared.registerSettingsNotifications(subtitle: "Able Sisters Shop is open", hour: 9, minute: 0, isRepeated: true)
        NotificationManager.shared.registerSettingsNotifications(subtitle: "Able Sisters Shop is closing in 1h", hour: 20, minute: 0, isRepeated: true)
    }
}

