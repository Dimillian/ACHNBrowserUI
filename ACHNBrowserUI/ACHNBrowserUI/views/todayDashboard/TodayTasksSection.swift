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
    @ObservedObject var appUserDefaults = AppUserDefaults.shared
    
    var isSunday: Bool {
        Calendar.current.component(.weekday, from: Date()) == 1
    }
    
    // MARK: - Task Bubble
    private func makeTaskBubble(icon: String, task: Tasks.TaskProgress) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color("ACBackground"))
            Image(icon)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
            if task.hasProgress || icon.elementsEqual("icon-turnip") && !self.isSunday {
                ProgressCircle(progress: task.progress)
            }
        }
        .frame(maxHeight: 44)
        .onTapGesture {
            if !task.hasProgress || icon.elementsEqual("icon-turnip") && !self.isSunday {
                return
            }
            // task.curProgress.updateProgress()
            // self.appUserDefaults.tasks.lastUpdate = Date.init()
            debugPrint(task.curProgress)
        }
    }
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Today's Tasks", icon: "checkmark.seal.fill")) {
            VStack(spacing: 15) {
                HStack {
                    makeTaskBubble(icon: "icon-iron", task: appUserDefaults.tasks.Rocks)
                    makeTaskBubble(icon: "icon-wood", task: appUserDefaults.tasks.Wood)
                    makeTaskBubble(icon: "icon-weed", task: appUserDefaults.tasks.Weed)
                    makeTaskBubble(icon: "icon-fossil", task: appUserDefaults.tasks.Fossils)
                }
                HStack {
                    makeTaskBubble(icon: "icon-bell", task: appUserDefaults.tasks.Bell)
                    makeTaskBubble(icon: "icon-miles", task: appUserDefaults.tasks.Miles)
                    makeTaskBubble(icon: "icon-helmet", task: appUserDefaults.tasks.VillagerHouses)
                    makeTaskBubble(icon: "icon-turnip", task: appUserDefaults.tasks.Turnip)
                        .opacity(isSunday ? 1.0 : 0.25)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
    
}

struct ProgressCircle: View {
    var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 4.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            Circle()
                .trim(from: 0.0, to: CGFloat(self.progress))
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
    }
}
