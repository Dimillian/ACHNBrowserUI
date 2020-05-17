//
//  Tasks.swift
//  ACHNBrowserUI
//
//  Created by Jan van Heesch on 17/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

public class Tasks: ObservableObject {
    public static let shared = Tasks()

    public class Task: ObservableObject {
        public let hasProgress: Bool
        public let maxProgress: Int
        @Published public var curProgress: Int = 0
        
        public init(hasProgress: Bool, maxProgress: Int) {
            self.hasProgress = hasProgress
            self.maxProgress = maxProgress
        }
    }

    public var lastUpdate = Date.init()
    @Published public var Rocks = Task(hasProgress: true, maxProgress: 8)
    @Published public var Wood = Task(hasProgress: false, maxProgress: 1)
    @Published public var Fossils = Task(hasProgress: true, maxProgress: 4)
    @Published public var Weed = Task(hasProgress: true, maxProgress: 3)
    @Published public var Bell = Task(hasProgress: true, maxProgress: 1)
    @Published public var Miles = Task(hasProgress: true, maxProgress: 1)
    @Published public var VillagerHouses = Task(hasProgress: true, maxProgress: 3)
    @Published public var Turnip = Task(hasProgress: true, maxProgress: 1)
    
    public func updateProgress(task: Task) {
        lastUpdate = Date.init()
        task.curProgress += 1
        if task.curProgress > task.maxProgress {
            task.curProgress = 0
        }
    }

}
