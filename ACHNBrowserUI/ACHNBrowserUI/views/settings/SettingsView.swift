//
//  SettingsView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 18/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedEmisphere = 0
    @Environment(\.presentationMode) private var presentationMode
    
    var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Island")) {
                    Picker(selection: $selectedEmisphere,
                           label: Text("Emisphere")) {
                            Text("North").tag(0)
                            Text("South").tag(1)
                    }
                }
                Button(action: {
                    AppUserDefaults.emisphere = self.selectedEmisphere == 0 ? "north" : "south"
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Save").foregroundColor(.grass)
                })
            }
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(trailing: closeButton)
        }.onAppear {
            self.selectedEmisphere = AppUserDefaults.emisphere == "north" ? 0 : 1
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
