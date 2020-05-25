//
//  TodayTasksSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/8/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import Backend

struct TodayTasksSection: View {
    @EnvironmentObject private var collection: UserCollection
    
    var isSunday: Bool {
        Calendar.current.component(.weekday, from: Date()) == 1
    }
    
    // MARK: - Task Bubble
    private func makeTaskBubble(icon: String, taskName: DailyTasks.taskName) -> some View {
        var task: DailyTasks.Task {
            collection.dailyTasks.tasks[taskName]!
        }
        
        return ZStack {
            Circle()
                .foregroundColor(Color("ACBackground"))
            Image(icon)
                .resizable()
                .aspectRatio(taskName == DailyTasks.taskName.villagerHouses ? 0.8 : 1, contentMode: .fit)
            if task.hasProgress {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 4.0)
                        .opacity(0.3)
                        .foregroundColor(Color.red)
                    Circle()
                        .trim(from: 0.0, to: CGFloat(task.curProgress)/CGFloat(task.maxProgress))
                        .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.green)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.easeInOut)
                }
            }
        }
        .frame(maxHeight: 44)
        .onTapGesture {
            if !task.hasProgress {
                return
            }
            self.collection.updateProgress(taskName: taskName)
        }
        .onLongPressGesture {
            guard task.hasProgress else { return }
            self.collection.resetProgress(taskName: taskName)
        }
    }
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Today's Tasks", icon: "checkmark.seal.fill")) {
            VStack(spacing: 15) {
                HStack {
                    makeTaskBubble(icon: "icon-iron", taskName: DailyTasks.taskName.rocks)
                    makeTaskBubble(icon: "icon-villager", taskName: DailyTasks.taskName.villagers)
                    makeTaskBubble(icon: "icon-fossil", taskName: DailyTasks.taskName.fossils)
                    makeTaskBubble(icon: "icon-leaf", taskName: DailyTasks.taskName.furniture)
                }
                HStack {
                    makeTaskBubble(icon: "icon-bell", taskName: DailyTasks.taskName.bell)
                    makeTaskBubble(icon: "icon-miles", taskName: DailyTasks.taskName.nookmiles)
                    makeTaskBubble(icon: "icon-bottle-message", taskName: DailyTasks.taskName.bottle)
                    makeTaskBubble(icon: "icon-recipe", taskName: DailyTasks.taskName.villagerHouses)
                }
                HStack {
                    Text("Reset")
                        .onTapGesture {
                            self.collection.resetTasks()
                    }
                    .foregroundColor(.acText)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 14)
                    .background(Color.acText.opacity(0.2))
                    .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
    
}

struct TodayTasksSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayTasksSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
