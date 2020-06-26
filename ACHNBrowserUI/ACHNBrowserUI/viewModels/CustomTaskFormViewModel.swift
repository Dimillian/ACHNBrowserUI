//
//  CustomTaskFormViewModel.swift
//  ACHNBrowserUI
//
//  Created by Jan on 30.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

class CustomTaskFormViewModel: ObservableObject {
    @Published var task: DailyCustomTasks.CustomTask
    @Published var selectedIcon: String? {
        didSet {
            if let icon = selectedIcon {
                task.icon = icon
            }
        }
    }
    
    private var editing = false
    
    init(editingTask: DailyCustomTasks.CustomTask?) {
        if let task = editingTask {
            self.editing = true
            self.task = task
        } else {
            self.task = DailyCustomTasks.CustomTask()
        }
    }
    
    func save() {
        if editing {
            UserCollection.shared.editCustomTask(task: task)
        } else {
            UserCollection.shared.addCustomTask(task: task)
        }
    }
}
