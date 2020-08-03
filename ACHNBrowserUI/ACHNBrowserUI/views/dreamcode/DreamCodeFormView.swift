//
//  DreamCodeFormView.swift
//  ACHNBrowserUI
//
//  Created by Jan van Heesch on 02.08.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import SwiftUIKit

struct DreamCodeFormView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    let isEditing: DreamCode?
    
    @State private var dreamCode = ""
    @State private var islandName = AppUserDefaults.shared.islandName
    @State private var text = ""
    @State private var hemisphere = AppUserDefaults.shared.hemisphere
    @State private var dreamCodeError = false
    @State private var validationError = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: footer) {
                    if validationError {
                        Text("Please fill all the fields").foregroundColor(.red)
                    }
                    TextField("Dream code", text: $dreamCode,
                              onEditingChanged: { _ in
                                self.checkDreamCode()
                    })
                    .foregroundColor(.dreamCode)
                    .font(.custom("CourierNewPS-BoldMT", size: 20))
                    .autocapitalization(.allCharacters)
                    if dreamCodeError {
                        Text("This Dream code is invalid").foregroundColor(.red)
                    }
                    TextField("Island name", text: $islandName)
                    TextField("Island description", text: $text)
                    Picker(selection: $hemisphere,
                           label: Text("Hemisphere")) {
                            ForEach(Hemisphere.allCases, id: \.self) { hemispehere in
                                Text(LocalizedStringKey(hemispehere.rawValue.capitalized)).tag(hemispehere)
                            }
                    }
                }
            }
            .navigationBarItems(leading: dismissButton, trailing: saveButton)
            .navigationBarTitle(isEditing != nil ? LocalizedStringKey("Edit your Dream code") : LocalizedStringKey("Add your Dream code"),
                                displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            if let editing = self.isEditing {
                self.islandName = editing.islandName
                self.dreamCode = editing.code
                self.text = editing.text
                self.hemisphere = editing.hemisphere
            }
        }
    }
    
    private var footer: some View {
        Text("dreamcode.footer")
    }
    
    private func checkDreamCode() {
        if !dreamCode.isEmpty && dreamCode.count != 17 {
            dreamCodeError = true
            return
        }
        dreamCodeError = false
    }
    
    private func checkForMissingField() {
        if islandName.isEmpty ||
            dreamCode.isEmpty ||
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
            self.checkDreamCode()
            if self.validationError || self.dreamCodeError {
                return
            }
            var code = DreamCode(code: self.dreamCode,
                                islandName: self.islandName,
                                text: self.text,
                                hemisphere: self.hemisphere)
            if let record = self.isEditing?.record {
                code.record = record
                code.upvotes = self.isEditing?.upvotes ?? 0
                code.report = self.isEditing?.report ?? 0
                DreamCodeService.shared.edit(code: code)
            } else {
                DreamCodeService.shared.add(code: code)
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

#if DEBUG
struct DreamCodeFormView_Previews: PreviewProvider {
    static var previews: some View {
        DreamCodeFormView(isEditing: nil)
    }
}
#endif
