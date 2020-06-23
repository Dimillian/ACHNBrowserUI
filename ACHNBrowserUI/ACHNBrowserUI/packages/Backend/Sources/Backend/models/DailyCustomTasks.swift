//
//  DailyCustomTasks.swift
//
//
//  Created by Jan on 24.05.20.
//

import Foundation

public struct DailyCustomTasks: Codable {
    public struct CustomTask: Codable, Identifiable {
        public var id = UUID()
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
            self.init(name: "", icon: "", hasProgress: true, maxProgress: 1)
        }
    }

    public var lastUpdate = Date()
    public var tasks = [
        CustomTask(name: NSLocalizedString("Hit rocks", comment: ""), icon: "Inv87", hasProgress: true, maxProgress: 6),
        CustomTask(name: NSLocalizedString("Find fossils", comment: ""), icon: "Inv60", hasProgress: true, maxProgress: 4),
        CustomTask(name: NSLocalizedString("Talk to villager", comment: ""), icon: "icon-villager", hasProgress: true, maxProgress: 10),
        CustomTask(name: NSLocalizedString("Find furniture", comment: ""), icon: "Inv63", hasProgress: true, maxProgress: 2),
        CustomTask(name: NSLocalizedString("Find buried bell", comment: ""), icon: "Inv0", hasProgress: true, maxProgress: 1),
        CustomTask(name: NSLocalizedString("Use ATM", comment: ""), icon: "Inv110", hasProgress: true, maxProgress: 1),
        CustomTask(name: NSLocalizedString("Find bottle message", comment: ""), icon: "Inv105", hasProgress: true, maxProgress: 3),
        CustomTask(name: NSLocalizedString("Obtain DIY from villager", comment: ""), icon: "Inv48", hasProgress: true, maxProgress: 1)
    ]
}
