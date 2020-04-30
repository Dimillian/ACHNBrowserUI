//
//  SettingsView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 18/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct SettingsView: View {
    @State private var islandName = AppUserDefaults.islandName
    @State private var selectedHemisphere = AppUserDefaults.hemisphere
    @State private var selectedFruit = AppUserDefaults.fruit
    @State private var selectedNookShop = AppUserDefaults.nookShop
    @State private var selectedAbleSisters = AppUserDefaults.ableSisters
    @State private var selectedResidentService = AppUserDefaults.residentService
    
    @Environment(\.presentationMode) private var presentationMode
    
    var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Dismiss")
        })
    }
    
    var saveButton: some View {
        Button(action: {
            AppUserDefaults.islandName = self.islandName
            AppUserDefaults.hemisphere = self.selectedHemisphere
            AppUserDefaults.fruit = self.selectedFruit
            AppUserDefaults.nookShop = self.selectedNookShop
            AppUserDefaults.ableSisters = self.selectedAbleSisters
            AppUserDefaults.residentService = self.selectedResidentService
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
        })
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: SectionHeaderView(text: "Island")) {
                    HStack {
                        Text("Island name")
                        Spacer()
                        TextField("Your island name", text: $islandName)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    Picker(selection: $selectedHemisphere,
                           label: Text("Hemisphere")) {
                            ForEach(Hemisphere.allCases, id: \.self) { hemispehere in
                                Text(hemispehere.rawValue.capitalized).tag(hemispehere)
                            }
                    }
                    Picker(selection: $selectedFruit,
                           label: Text("Starting fruit")) {
                            ForEach(Fruit.allCases, id: \.self) { fruit in
                                Text(fruit.rawValue.capitalized).tag(fruit)
                            }
                    }
                    
                    Picker(selection: $selectedNookShop,
                           label: Text("Nook shop")) {
                            ForEach(Infrastructure.NookShop.allCases, id: \.self) { shop in
                                Text(shop.rawValue).tag(shop)
                            }
                    }
                    
                    Picker(selection: $selectedAbleSisters,
                           label: Text("Able sisters")) {
                            ForEach(Infrastructure.AbleSisters.allCases, id: \.self) { sisters in
                                Text(sisters.rawValue.capitalized).tag(sisters)
                            }
                    }
                    
                    Picker(selection: $selectedResidentService,
                           label: Text("Residents service")) {
                            ForEach(Infrastructure.ResidentService.allCases, id: \.self) { service in
                                Text(service.rawValue.capitalized).tag(service)
                            }
                    }
                }
                
                Section(header: SectionHeaderView(text: "App Settings")) {
                    NavigationLink(destination: AppIconPickerView()) {
                        Text("App Icon")
                    }
                }
                saveButton
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(leading: closeButton, trailing: saveButton)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
