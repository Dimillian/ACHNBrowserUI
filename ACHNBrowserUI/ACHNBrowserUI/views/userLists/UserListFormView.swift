//
//  UserListFormView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct UserListFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: UserListFormViewModel
    @State private var errorBorder: Color = .clear
    
    init(editingList: UserList?) {
        self.viewModel = UserListFormViewModel(editingList: editingList)
    }
    
    private var dismissButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Cancel").foregroundColor(.red)
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            guard !self.viewModel.list.name.isEmpty else {
                self.errorBorder = .red
                return
            }
            self.viewModel.save()
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Text("Save").foregroundColor(.grass2)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text("Name of your list")
                    Spacer()
                    TextField("List name",
                              text: $viewModel.list.name,
                              onEditingChanged: {_ in
                                self.errorBorder = .clear
                    })
                        .foregroundColor(.text)
                }
                .border(errorBorder)
                HStack {
                    Text("Description")
                    Spacer()
                    TextField("Can be nothing", text: $viewModel.list.description)
                        .foregroundColor(.text)
                }
                Picker(selection: $viewModel.selectedIcon,
                       label: Text("Icon")) {
                        ForEach(Category.allCases.map{ $0.iconName() }, id: \.self) { icon in
                            HStack {
                                Image(icon)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }.tag(icon)
                        }
                }
            }.navigationBarTitle("Edit your list")
            .navigationBarItems(leading: dismissButton, trailing: saveButton)
        }
    }
}

struct UserListFormView_Previews: PreviewProvider {
    static var previews: some View {
        UserListFormView(editingList: nil)
    }
}
