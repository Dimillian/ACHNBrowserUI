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
    @EnvironmentObject private var subscriptionManager: SubcriptionManager
    @Environment(\.presentationMode) private var presentationMode
    
    private var islandName = Binding<String>(get: {
        AppUserDefaults.islandName
    }, set: {
        AppUserDefaults.islandName = $0
    })
    
    private var selectedHemisphere =
        Binding<Hemisphere>(get: { AppUserDefaults.hemisphere }, set: { AppUserDefaults.hemisphere = $0 })
    
    private var selectedFruit =
        Binding<Fruit>(get: { AppUserDefaults.fruit }, set: { AppUserDefaults.fruit = $0 })
    
    private var selectedNookShop =
        Binding<Infrastructure.NookShop>(get: { AppUserDefaults.nookShop }, set: { AppUserDefaults.nookShop = $0 })
    
    private var selectedAbleSisters = Binding<Infrastructure.AbleSisters>(get: {
        AppUserDefaults.ableSisters
    }, set: {
        AppUserDefaults.ableSisters = $0
    })
    
    private var selectedResidentService = Binding<Infrastructure.ResidentService>(get: {
        AppUserDefaults.residentService
    }, set: {
        AppUserDefaults.residentService = $0
    })
    
    var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Dismiss")
        })
        .safeHoverEffectBarItem(position: .leading)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: SectionHeaderView(text: "Island")) {
                    HStack {
                        Text("Island name")
                        Spacer()
                        TextField("Your island name", text: islandName)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    Picker(selection: selectedHemisphere,
                           label: Text("Hemisphere")) {
                            ForEach(Hemisphere.allCases, id: \.self) { hemispehere in
                                Text(hemispehere.rawValue.capitalized).tag(hemispehere)
                            }
                    }
                    Picker(selection: selectedFruit,
                           label: Text("Starting fruit")) {
                            ForEach(Fruit.allCases, id: \.self) { fruit in
                                Text(fruit.rawValue.capitalized).tag(fruit)
                            }
                    }
                    
                    Picker(selection: selectedNookShop,
                           label: Text("Nook shop")) {
                            ForEach(Infrastructure.NookShop.allCases, id: \.self) { shop in
                                Text(shop.rawValue).tag(shop)
                            }
                    }
                    
                    Picker(selection: selectedAbleSisters,
                           label: Text("Able sisters")) {
                            ForEach(Infrastructure.AbleSisters.allCases, id: \.self) { sisters in
                                Text(sisters.rawValue.capitalized).tag(sisters)
                            }
                    }
                    
                    Picker(selection: selectedResidentService,
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
                    Button(action: {
                        self.subscriptionManager.restorePurchase()
                    }) {
                        if self.subscriptionManager.subscriptionStatus == .subscribed {
                            Text("You're subscribed to AC Helper+")
                                .foregroundColor(.secondaryText)
                        } else {
                            Text("Restore purchase")
                                .foregroundColor(.bell)
                        }
                    }
                    .disabled(subscriptionManager.inPaymentProgress)
                    .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
                }
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(leading: closeButton)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
