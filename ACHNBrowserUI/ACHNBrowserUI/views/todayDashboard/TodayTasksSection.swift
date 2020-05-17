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
    @EnvironmentObject var tasks: Tasks
    
    var isSunday: Bool {
        Calendar.current.component(.weekday, from: Date()) == 1
    }
    
    // MARK: - Task Bubble
    private func makeTaskBubble(icon: String, task: Tasks.Task) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color("ACBackground"))
            Image(icon)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            if task.hasProgress || icon.elementsEqual("icon-turnip") && !self.isSunday {
                ProgressCircle(task: task)
            }
        }
        .frame(maxHeight: 44)
        .onTapGesture {
            if !task.hasProgress || icon.elementsEqual("icon-turnip") && !self.isSunday {
                return
            }
            self.tasks.updateProgress(task: task)
        }
    }
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Today's Tasks", icon: "checkmark.seal.fill")) {
            VStack(spacing: 15) {
                HStack {
                    makeTaskBubble(icon: "icon-iron", task: self.tasks.Rocks)
                    makeTaskBubble(icon: "icon-wood", task: self.tasks.Wood)
                    makeTaskBubble(icon: "icon-weed", task: self.tasks.Weed)
                    makeTaskBubble(icon: "icon-fossil", task: self.tasks.Fossils)
                }
                HStack {
                    makeTaskBubble(icon: "icon-bell", task: self.tasks.Bell)
                    makeTaskBubble(icon: "icon-miles", task: self.tasks.Miles)
                    makeTaskBubble(icon: "icon-helmet", task: self.tasks.VillagerHouses)
                    makeTaskBubble(icon: "icon-turnip", task: self.tasks.Turnip)
                        .opacity(isSunday ? 1.0 : 0.25)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
    
}

struct ProgressCircle: View {
    @ObservedObject var task: Tasks.Task
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            Circle()
                .trim(from: 0.0, to: CGFloat(self.task.curProgress)/CGFloat(self.task.maxProgress))
                .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.green)
                .rotationEffect(Angle(degrees: 270.0))
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
        .environmentObject(Tasks.shared)
    }
}
