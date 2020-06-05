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
    @Environment(\.presentationMode) private var presentationMode
    @State private var errorBorderTaskName: Color = .clear
    @State private var errorBorderIcon: Color = .clear
    
    init(editingTask: DailyCustomTasks.CustomTask?) {
        self.viewModel = CustomTaskFormViewModel(editingTask: editingTask)
    }
    
    private var saveButton: some View {
        Button(action: {
            guard !self.viewModel.task.name.isEmpty else {
                self.errorBorderTaskName = .red
                return
            }
            guard !self.viewModel.task.icon.isEmpty else {
                self.errorBorderIcon = .red
                return
            }
            self.viewModel.save()
            self.presentationMode.wrappedValue.dismiss()
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
                Text("Task name")
                Spacer()
                TextField("Name of the task",
                          text: $viewModel.task.name,
                          onEditingChanged: { _ in
                            self.errorBorderTaskName = .clear
                })
                .multilineTextAlignment(.trailing)
                .foregroundColor(.acText)
            }
            .border(errorBorderTaskName)
            Picker(selection: $viewModel.task.icon,
               label: Text("Icon")) {
                ForEach(DailyCustomTasks.icons.map { $0 }, id: \.self) { icon in
                    HStack {
                        Image(icon)
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 40, height: 40)
                    }.tag(icon)
                }
            }
            .border(self.viewModel.task.icon.isEmpty ? errorBorderIcon : .clear)
            Toggle(isOn: $viewModel.task.hasProgress) {
                Text("Has progress")
            }
            if self.viewModel.task.hasProgress {
                Picker(selection: $viewModel.task.maxProgress,
                       label: Text("Max amount")) {
                        ForEach(0..<46) {
                            if $0 > 0 {
                                Text("\($0)")
                            }
                        }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Edit task")
        .navigationBarItems(trailing: saveButton)
    }
}

struct CutomTaskFormView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CustomTaskFormView(editingTask: nil)
        }
    }
}
