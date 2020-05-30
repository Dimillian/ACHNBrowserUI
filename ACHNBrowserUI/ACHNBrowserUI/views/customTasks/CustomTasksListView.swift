//
//  CustomTasksListView.swift
//  ACHNBrowserUI
//
//  Created by Jan on 24.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct CustomTasksListView: View {
    @EnvironmentObject private var collection: UserCollection
    @Environment(\.presentationMode) private var presentationMode
    
    private var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        })
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
        .safeHoverEffectBarItem(position: .leading)
    }
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    ForEach(collection.dailyCustomTasks.tasks) { task in
                        NavigationLink(destination: CustomTaskFormView(editingTask: nil)) {
                            CustomTaskRow(task: task)
                        }
                    }.onDelete { indexes in
                        self.collection.deleteCustomTask(at: indexes.first!)
                    }
                    NavigationLink(destination: CustomTaskFormView(editingTask: nil)) {
                        Text("Add a custom task").foregroundColor(.acHeaderBackground)
                    }
                }
            }
            .environment(\.horizontalSizeClass, .regular)
                .navigationBarTitle(Text("Custom tasks"), displayMode: .inline)
                .navigationBarItems(leading: closeButton)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
