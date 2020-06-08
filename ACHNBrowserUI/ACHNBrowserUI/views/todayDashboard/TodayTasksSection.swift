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
    
    private var rows: Int {
        var rowsFloat = CGFloat(tasksCount) / 4.0
        rowsFloat.round(.up)
        return Int(rowsFloat)
    }
        
    // MARK: - Task Bubble
    private func makeTaskBubble(task: DailyCustomTasks.CustomTask, index: Int) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color("ACBackground"))
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
            guard task.hasProgress else { return }
            self.collection.updateProgress(taskId: index)
            FeedbackGenerator.shared.triggerSelection()
        }
        .onLongPressGesture {
            guard task.hasProgress else { return }
            self.collection.resetProgress(taskId: index)
            FeedbackGenerator.shared.triggerSelection()
        }
    }
    
    var body: some View {
        VStack(spacing: 15) {
            GridStack<AnyView>(rows: rows, columns: 4, showDivider: false) { (row, column) in
                let taskId = row * 4 + column
                guard let task = self.collection.dailyCustomTasks.tasks[safe: taskId] else {
                    return EmptyView().eraseToAnyView()
                }
                return self.makeTaskBubble(task: task, index: taskId).eraseToAnyView()
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
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.sizeThatFits)
        .environmentObject(UserCollection.shared)
    }
}
