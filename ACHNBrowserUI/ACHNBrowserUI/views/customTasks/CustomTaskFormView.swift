//
//  CustomTaskFormView.swift
//  ACHNBrowserUI
//
//  Created by Jan on 30.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct CustomTaskFormView: View {
    @ObservedObject private var viewModel: CustomTaskFormViewModel
    @State private var errorBorder: Color = .clear
    
    init(editingTask: DailyCustomTasks.CustomTask?) {
        self.viewModel = CustomTaskFormViewModel(editingTask: editingTask)
    }
    
    private var saveButton: some View {
        Button(action: {
            guard !self.viewModel.task.name.isEmpty else {
                self.errorBorder = .red
                return
            }
            self.viewModel.save()
        }) {
            Image(systemName: "checkmark.seal.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.acTabBarBackground)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acTabBarBackground.opacity(0.2))
    }
    
    var body: some View {
        Form {
            HStack {
                Text("Name of your task")
                Spacer()
                TextField("Task name",
                          text: $viewModel.task.name,
                          onEditingChanged: {_ in
                            self.errorBorder = .clear
                })
                .foregroundColor(.acText)
            }
            .border(errorBorder)
            Picker(selection: $viewModel.selectedIcon,
               label: Text("Icon")) {
                ForEach(DailyCustomTasks.icons().map{ $0 }, id: \.self) { icon in
                    HStack {
                        Image(icon)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }.tag(icon)
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Edit your task")
        .navigationBarItems(trailing: saveButton)
    }
}

struct CutomTaskFormView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTaskFormView(editingTask: nil)
    }
}
