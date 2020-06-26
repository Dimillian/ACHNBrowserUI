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
    @Binding var sheet: Sheet.SheetType?
    
    private var tasksCount: Int {
        collection.dailyCustomTasks.tasks.count
    }
            
    // MARK: - Task Bubble
    private func makeTaskBubble(task: DailyCustomTasks.CustomTask) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color.acBackground)
            Image(task.icon)
                .resizable()
                .scaleEffect(0.9)
                .aspectRatio(contentMode: .fit)
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
            guard task.hasProgress,
                  let index = collection.dailyCustomTasks.tasks.firstIndex(where: { $0.id == task.id})
            else { return }
            collection.updateProgress(taskId: index)
            FeedbackGenerator.shared.triggerSelection()
        }
        .onLongPressGesture {
            guard task.hasProgress,
                  let index = collection.dailyCustomTasks.tasks.firstIndex(where: { $0.id == task.id})
            else { return }
            collection.resetProgress(taskId: index)
            FeedbackGenerator.shared.triggerSelection()
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50)), count: 4),
                      alignment: .center,
                      spacing: 16) {
                ForEach(collection.dailyCustomTasks.tasks) { task in
                    makeTaskBubble(task: task)
                }
            }
            HStack {
                Spacer()
                Text("Edit")
                    .onTapGesture {
                        self.sheet = .customTasks(collection: self.collection)
                }
                .foregroundColor(.acText)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(Color.acText.opacity(0.2))
                .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
                Spacer()
                Text("Reset")
                    .onTapGesture {
                        self.collection.resetTasks()
                }
                .foregroundColor(.acText)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(Color.acText.opacity(0.2))
                .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
                Spacer()
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

struct TodayTasksSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayTasksSection(sheet: .constant(nil))
            }
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(UserCollection.shared)
    }
}
