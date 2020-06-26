//
//  DodoCodeFormView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 12/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import SwiftUIKit

struct DodoCodeFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let isEditing: DodoCode?
    
    @ObservedObject private var dodoCode = DodoCodeBinding()
    @State private var islandName = AppUserDefaults.shared.islandName
    @State private var text = ""
    @State private var fruit = AppUserDefaults.shared.fruit
    @State private var hemisphere = AppUserDefaults.shared.hemisphere
    @State private var haveVisitor = false
    @State private var visitor: SpecialCharacters?
    @State private var dodoCodeError = false
    @State private var validationError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: footer) {
                    Group {
                        if validationError {
                            Text("Please fill all the fields")
                                .foregroundColor(.red)
                                .listRowBackground(Color.acSecondaryBackground)
                        }
                        TextField("Dodo code", text: $dodoCode.code,
                                  onEditingChanged: { _ in
                                    self.checkDodoCode()
                                  })
                            .listRowBackground(Color.acSecondaryBackground)
                            .foregroundColor(.acHeaderBackground)
                            .font(.custom("CourierNewPS-BoldMT", size: 20))
                            .autocapitalization(.allCharacters)
                        if dodoCodeError {
                            Text("This Dodo code is invalid").foregroundColor(.red)
                        }
                        TextField("Island name", text: $islandName)
                        TextField("Island description", text: $text)
                        Picker(selection: $hemisphere,
                               label: Text("Hemisphere")) {
                            ForEach(Hemisphere.allCases, id: \.self) { hemispehere in
                                Text(LocalizedStringKey(hemispehere.rawValue.capitalized))
                                    .tag(hemispehere)
                            }
                        }
                        Picker(selection: $fruit,
                               label: Text("Native fruit")) {
                            ForEach(Fruit.allCases, id: \.self) { fruit in
                                HStack {
                                    Image(fruit.rawValue.capitalized)
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Text(LocalizedStringKey(fruit.rawValue.capitalized)).tag(fruit)
                                }
                            }
                        }
                        Picker(selection: $visitor,
                               label: Text("Visitor")) {
                            ForEach(SpecialCharacters.allCases, id: \.self) { visitor in
                                HStack {
                                    Image(visitor.rawValue)
                                        .renderingMode(.original)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                    Text(LocalizedStringKey(visitor.rawValue.capitalized))
                                }
                                .tag(visitor as SpecialCharacters?)
                            }
                        }
                    }.listRowBackground(Color.acSecondaryBackground)
                }
            }
            .navigationBarItems(leading: dismissButton, trailing: saveButton)
            .navigationBarTitle(isEditing != nil ? "Edit your Dodo code" : "Add your Dodo code",
                                displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if let editing = self.isEditing {
                self.islandName = editing.islandName
                self.dodoCode.code = editing.code
                self.text = editing.text
                self.hemisphere = editing.hemisphere
                self.fruit = editing.fruit
                self.visitor = editing.specialCharacter
            }
        }
    }
    
    private var footer: some View {
        Text("dodocode.footer")
    }
    
    private func checkDodoCode() {
        if !dodoCode.code.isEmpty && dodoCode.code.count != 5 {
            dodoCodeError = true
            return
        }
        dodoCodeError = false
    }
    
    private func checkForMissingField() {
        if islandName.isEmpty ||
            dodoCode.code.isEmpty ||
            text.isEmpty {
            validationError = true
            return
        }
        validationError = false
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
            self.checkForMissingField()
            self.checkDodoCode()
            if self.validationError || self.dodoCodeError {
                return
            }
            var code = DodoCode(code: self.dodoCode.code,
                                islandName: self.islandName,
                                text: self.text,
                                fruit: self.fruit,
                                hemisphere: self.hemisphere,
                                specialCharacter: self.visitor)
            if let record = self.isEditing?.record {
                code.record = record
                code.upvotes = self.isEditing?.upvotes ?? 0
                code.report = self.isEditing?.report ?? 0
                DodoCodeService.shared.edit(code: code)
            } else {
                DodoCodeService.shared.add(code: code)
            }
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "checkmark.seal.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.acTabBarBackground)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acTabBarBackground.opacity(0.2))
    }
}

class DodoCodeBinding: ObservableObject {
    @Published var code = "" {
        didSet {
            if code.count > 5 && oldValue.count <= 5 {
                code = oldValue
            }
        }
    }
}

struct DodoCodeFormView_Previews: PreviewProvider {
    static var previews: some View {
        DodoCodeFormView(isEditing: nil)
    }
}
