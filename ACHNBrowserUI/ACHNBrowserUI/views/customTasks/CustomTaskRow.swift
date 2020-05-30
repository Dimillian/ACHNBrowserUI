//
//  CustomTaskRow.swift
//  ACHNBrowserUI
//
//  Created by Jan on 30.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CustomTaskRow: View {
    let task: DailyCustomTasks.CustomTask
    
    var body: some View {
        HStack {
            Image(task.icon).resizable().frame(width: 30, height: 30)
            HStack {
                VStack(alignment: .leading) {
                    Text(task.name).style(appStyle: .rowTitle).lineLimit(1)
                }
            }
        }
    }
}
