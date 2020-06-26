//
//  UserListFormView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct UserListFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject private var viewModel: UserListFormViewModel
    @State private var errorBorder: Color = .clear
    @State private var presentedSheet: Sheet.SheetType?
    
    init(editingList: UserList?) {
        self.viewModel = UserListFormViewModel(editingList: editingList)
    }
    
    private var dismissButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "xmark.circle.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.red)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.red.opacity(0.2))
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
            Image(systemName: "checkmark.seal.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.acTabBarBackground)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acTabBarBackground.opacity(0.2))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Group {
                    HStack {
                        Text("Name of your list")
                        Spacer()
                        TextField("List name",
                                  text: $viewModel.list.name,
                                  onEditingChanged: {_ in
                                    self.errorBorder = .clear
                                  })
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.acText)
                    }
                    .border(errorBorder)
                    HStack {
                        Text("Description")
                        Spacer()
                        TextField("Can be nothing", text: $viewModel.list.description)
                            .multilineTextAlignment(.trailing)
                            .foregroundColor(.acText)
                    }
                    
                    Button(action: {
                        presentedSheet = .iconChooser(icon: $viewModel.selectedIcon)
                    }) {
                        HStack {
                            Text("Icon").foregroundColor(.black)
                            Spacer()
                            if let icon = viewModel.selectedIcon {
                                Image(icon)
                                    .renderingMode(.original)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                        }
                    }
                }.listRowBackground(Color.acSecondaryBackground)
                
            }
            .navigationBarTitle("Edit your list")
            .navigationBarItems(leading: dismissButton, trailing: saveButton)
            .sheet(item: $presentedSheet, content: { Sheet(sheetType: $0) })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct UserListFormView_Previews: PreviewProvider {
    static var previews: some View {
        UserListFormView(editingList: nil)
    }
}
