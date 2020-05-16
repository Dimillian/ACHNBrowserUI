//
//  TaskProgress.swift
//  
//
//  Created by Jan van Heesch on 16.05.20.
//

import Foundation

public struct Tasks {

    public struct TaskProgress {
        public let hasProgress: Bool
        public let maxProgress: Int
        public var curProgress: Int = 0
        
        public var progress: Float {
            return Float(self.curProgress/self.maxProgress)
        }
        
        public init(hasProgress: Bool, maxProgress: Int) {
            self.hasProgress = hasProgress
            self.maxProgress = maxProgress
        }
        
        public mutating func updateProgress() {
            curProgress += 1
            if curProgress > maxProgress {
               curProgress = 0
            }
        }
    }

    public var lastUpdate: Date
    public var Rocks: TaskProgress = TaskProgress(hasProgress: true, maxProgress: 8)
    public var Wood: TaskProgress = TaskProgress(hasProgress: false, maxProgress: 1)
    public var Fossils: TaskProgress = TaskProgress(hasProgress: true, maxProgress: 4)
    public var Weed: TaskProgress = TaskProgress(hasProgress: true, maxProgress: 3)
    public var Bell: TaskProgress = TaskProgress(hasProgress: true, maxProgress: 8)
    public var Miles: TaskProgress = TaskProgress(hasProgress: true, maxProgress: 1)
    public var VillagerHouses: TaskProgress = TaskProgress(hasProgress: true, maxProgress: 3)
    public var Turnip: TaskProgress = TaskProgress(hasProgress: true, maxProgress: 1)

}
