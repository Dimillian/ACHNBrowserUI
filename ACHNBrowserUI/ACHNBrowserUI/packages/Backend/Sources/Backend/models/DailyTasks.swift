//
//  File.swift
//  
//
//  Created by Jan on 19.05.20.
//

import Foundation

public struct DailyTasks: Codable {
    
    public struct Task: Codable {
        public let hasProgress: Bool
        public let maxProgress: Int
        public var curProgress = 0 {
            didSet {
                if curProgress > maxProgress {
                    curProgress = 0
                }
            }
        }
        
        public init(hasProgress: Bool, maxProgress: Int) {
            self.hasProgress = hasProgress
            self.maxProgress = maxProgress
        }
        
        public mutating func increaseProgress() {
            curProgress += 1
            
            if curProgress > maxProgress {
                curProgress = 1
            }
        }
    }

    public var lastUpdate = Date.init()
    public var tasks = [
        "rocks": Task(hasProgress: true, maxProgress: 8),
        "wood": Task(hasProgress: false, maxProgress: 1),
        "fossils": Task(hasProgress: true, maxProgress: 4),
        "weed": Task(hasProgress: true, maxProgress: 3),
        "bell": Task(hasProgress: true, maxProgress: 1),
        "nookmiles": Task(hasProgress: true, maxProgress: 1),
        "villagerHouses": Task(hasProgress: true, maxProgress: 3),
        "turnip": Task(hasProgress: true, maxProgress: 1)
    ]

    public mutating func updated() {
        lastUpdate = Date.init()
    }
}
