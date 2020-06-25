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
    @State private var editMode = EditMode.inactive
    
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
    
    private var orderButton: some View {
        Button(action: { self.editMode.toggle() }, label: {
            if self.editMode == EditMode.active {
                Image(systemName: "checkmark.seal.fill")
                    .style(appStyle: .barButton)
                    .foregroundColor(.acTabBarBackground)
            }
            else {
                Image(systemName: "arrow.up.arrow.down.circle.fill")
                    .style(appStyle: .barButton)
                    .foregroundColor(.acText)
            }
        })
        .buttonStyle(BorderedBarButtonStyle())
            .accentColor(self.editMode == EditMode.active ?
                Color.acTabBarBackground.opacity(0.2) : Color.acText.opacity(0.2))
    }
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    ForEach(collection.dailyCustomTasks.tasks) { task in
                        NavigationLink(destination: CustomTaskFormView(editingTask: task)) {
                            CustomTaskRow(task: task)
                        }.listRowBackground(Color.acSecondaryBackground)
                    }
                    .onMove(perform: onMove)
                    .onDelete { indexes in
                        guard let index = indexes.first else { return }
                        self.collection.deleteCustomTask(at: index)
                    }
                    NavigationLink(destination: CustomTaskFormView(editingTask: nil)) {
                        Image(systemName: "plus")
                            .frame(width: 30, height: 30)
                            .foregroundColor(.acHeaderBackground)
                        Text("Add a custom task")
                            .foregroundColor(.acHeaderBackground)
                    }.listRowBackground(Color.acSecondaryBackground)
                }
            }
            .environment(\.editMode, $editMode)
            .navigationBarTitle(Text("Today's Tasks"), displayMode: .inline)
            .navigationBarItems(leading: closeButton, trailing: orderButton)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    private func onMove(source: IndexSet, destination: Int) {
        self.collection.moveCustomTask(from: source, to: destination)
    }
}

struct CustomTaskListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTasksListView()
        .previewLayout(.sizeThatFits)
        .environmentObject(UserCollection.shared)
    }
}
