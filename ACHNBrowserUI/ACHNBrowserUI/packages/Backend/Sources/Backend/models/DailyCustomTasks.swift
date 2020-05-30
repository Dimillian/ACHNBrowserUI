//
//  DailyCustomTasks.swift
//
//
//  Created by Jan on 24.05.20.
//

import Foundation

public struct DailyCustomTasks: Codable {
    public struct CustomTask: Codable, Identifiable {
        public let id = UUID()
        public var name: String
        public var icon: String
        public var hasProgress: Bool
        public var maxProgress: Int
        public var curProgress = 0
        
        public init(name: String, icon: String, hasProgress: Bool, maxProgress: Int) {
            self.name = name
            self.icon = icon
            self.hasProgress = hasProgress
            self.maxProgress = maxProgress
        }
        
        public init() {
            self.init(name: "", icon: "icon-leaf", hasProgress: true, maxProgress: 1)
        }
    }

    public var lastUpdate = Date()
    public var tasks = [
        CustomTask(name: "Hit rocks", icon: "icon-iron", hasProgress: true, maxProgress: 8),
        CustomTask(name: "Find fossils", icon: "icon-fossil", hasProgress: true, maxProgress: 4),
        CustomTask(name: "Talk to villager", icon: "icon-villager", hasProgress: true, maxProgress: 10),
        CustomTask(name: "Find furniture", icon: "icon-leaf", hasProgress: true, maxProgress: 2),
        CustomTask(name: "Find buried bell", icon: "icon-bell", hasProgress: true, maxProgress: 1),
        CustomTask(name: "Use ATM", icon: "icon-miles", hasProgress: true, maxProgress: 1),
        CustomTask(name: "Find bottle message", icon: "icon-bottle-message", hasProgress: true, maxProgress: 3),
        CustomTask(name: "Obtain DIY from villager", icon: "icon-recipe", hasProgress: true, maxProgress: 1)
    ]
    
    public static func icons() -> [String] {
        return [
            "icon-leaf", "icon-mapple-leaf", "icon-miles", "icon-mushroom1",
            "icon-art", "icon-mushroom2", "icon-bag", "icon-mushroom3",
            "icon-bamboo-spring", "icon-mushroom4", "icon-bamboo", "icon-paint",
            "icon-bell", "icon-pant", "icon-bells-tabbar", "icon-photos",
            "icon-bells", "icon-posters", "icon-bottle-message", "icon-present",
            "icon-branch", "icon-present2", "icon-cardboard-tabbar", "icon-recipe",
            "icon-cardboard", "icon-rug", "icon-clay", "icon-shoes",
            "icon-fence", "icon-socks", "icon-fish", "icon-softwood",
            "icon-floor", "icon-song", "icon-fossil", "icon-tool",
            "icon-glasses", "icon-top", "icon-gold", "icon-turnip-tabbar",
            "icon-hardwood", "icon-turnip", "icon-helm", "icon-umbrella",
            "icon-helmet", "icon-villager-tabbar", "icon-housewares", "icon-villager",
            "icon-insect", "icon-wallmounted", "icon-iron", "icon-wallpaper",
            "icon-leaf-design", "icon-weed", "icon-leaf-tabbar", "icon-wood"
        ]
    }
}
