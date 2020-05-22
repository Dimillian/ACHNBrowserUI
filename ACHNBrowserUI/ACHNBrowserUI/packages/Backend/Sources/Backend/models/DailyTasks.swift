//
//  DailyTasks.swift
//  
//
//  Created by Jan on 19.05.20.
//

import Foundation

public struct DailyTasks: Codable {
    public struct Task: Codable {
        public let hasProgress: Bool
        public let maxProgress: Int
        public var curProgress = 0
        
        public init(hasProgress: Bool, maxProgress: Int) {
            self.hasProgress = hasProgress
            self.maxProgress = maxProgress
        }
    }
    
    public enum taskName: String, Codable, CaseIterable {
        case rocks
        case fossils
        case villagers
        case furniture
        case bell
        case nookmiles
        case villagerHouses
        case bottle
    }

    public var lastUpdate = Date()
    public var tasks = [
        taskName.rocks: Task(hasProgress: true, maxProgress: 8),
        taskName.fossils: Task(hasProgress: true, maxProgress: 4),
        taskName.villagers: Task(hasProgress: true, maxProgress: 10),
        taskName.furniture: Task(hasProgress: true, maxProgress: 2),
        taskName.bell: Task(hasProgress: true, maxProgress: 1),
        taskName.nookmiles: Task(hasProgress: true, maxProgress: 1),
        taskName.villagerHouses: Task(hasProgress: true, maxProgress: 3),
        taskName.bottle: Task(hasProgress: true, maxProgress: 1)
    ]
}
