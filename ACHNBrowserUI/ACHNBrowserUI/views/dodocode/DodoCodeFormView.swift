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
    
    @State private var islandName = AppUserDefaults.shared.islandName
    @State private var dodoCode = ""
    @State private var text = ""
    @State private var fruit = AppUserDefaults.shared.fruit
    @State private var hemisphere = AppUserDefaults.shared.hemisphere
    @State private var dodoCodeError = false
    @State private var validationError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: footer) {
                    if validationError {
                        Text("Please fill all the fields").foregroundColor(.red)
                    }
                    TextField("Dodo code", text: $dodoCode,
                              onEditingChanged: { _ in
                                self.checkDodoCode()
                    }).foregroundColor(.acHeaderBackground)
                    if dodoCodeError {
                        Text("This Dodo code is invalid").foregroundColor(.red)
                    }
                    TextField("Island name", text: $islandName)
                    TextField("Island description", text: $text)
                    Picker(selection: $hemisphere,
                           label: Text("Hemisphere")) {
                            ForEach(Hemisphere.allCases, id: \.self) { hemispehere in
                                Text(LocalizedStringKey(hemispehere.rawValue.capitalized)).tag(hemispehere)
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
                }
            }
            .navigationBarItems(leading: dismissButton, trailing: saveButton)
            .navigationBarTitle("Add your Dodo code", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var footer: some View {
        Text("dodocode.footer")
    }
    
    private func checkDodoCode() {
        if !dodoCode.isEmpty && dodoCode.count != 5 {
            dodoCodeError = true
            return
        }
        dodoCodeError = false
    }
    
    private func checkForMissingField() {
        if islandName.isEmpty ||
            dodoCode.isEmpty ||
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
            let code = DodoCode(code: self.dodoCode,
                                islandName: self.islandName,
                                text: self.text,
                                fruit: self.fruit,
                                hemisphere: self.hemisphere)
            DodoCodeService.shared.add(code: code)
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

struct DodoCodeFormView_Previews: PreviewProvider {
    static var previews: some View {
        DodoCodeFormView()
    }
}
