//
//  SettingsView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 18/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend
import UniformTypeIdentifiers

struct SettingsView: View {
    @EnvironmentObject private var collection: UserCollection
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var appUserDefaults = AppUserDefaults.shared
    
    private let types = [UTType("com.thomasricouard.ACNH.achelper")!]
    
    @State private var showSuccessImportAlert = false
    @State private var showDeleteConfirmationAlert = false
    @State private var isImporting = false
    @State private var isExporting = false
    
    var body: some View {
        NavigationView {
            Form {
                islandSection
                appSection
                dataSection
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(leading: closeButton)
        }
        .fileImporter(isPresented: $isImporting,
                      allowedContentTypes: types) { result in
            if let url = try? result.get() {
                showSuccessImportAlert = collection.processImportedFile(url: url)
            }
        }
        .fileMover(isPresented: $isExporting,
                   file: collection.generateExportURL()) { _ in }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var importSuccessAlert: Alert {
        Alert(title: Text("Imported with success"),
              message: Text("Your AC Helper collection file was imported with success."),
              dismissButton: .default(Text("Ok")))
    }
    
    private var deleteConfirmationAlert: Alert {
        Alert(title: Text("Are you sure?"),
              message: Text("This will delete all your collected critters, items, villagers and items lists"), primaryButton: .destructive(Text("Delete"), action: {
                _ = self.collection.deleteCollection()
              }), secondaryButton: .cancel())
    }
    
    private var closeButton: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark.circle.fill")
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        })
            .buttonStyle(BorderedBarButtonStyle())
            .accentColor(Color.acText.opacity(0.2))
            .safeHoverEffectBarItem(position: .leading)
    }

    
    private var islandSection: some View {
        Section(header: SectionHeaderView(text: "Island", icon: "sun.haze")) {
            HStack {
                Text("Island name")
                Spacer()
                TextField("Your island name", text: $appUserDefaults.islandName)
                    .multilineTextAlignment(.trailing)
                    .font(.body)
                    .foregroundColor(.secondary)
            }.listRowBackground(Color.acSecondaryBackground)
            HStack {
                Text("In game name / username")
                Spacer()
                TextField("Your username", text: $appUserDefaults.inGameName)
                    .multilineTextAlignment(.trailing)
                    .font(.body)
                    .foregroundColor(.secondary)
            }.listRowBackground(Color.acSecondaryBackground)
            Picker(selection: $appUserDefaults.hemisphere,
                   label: Text("Hemisphere")) {
                    ForEach(Hemisphere.allCases, id: \.self) { hemispehere in
                        Text(LocalizedStringKey(hemispehere.rawValue.capitalized)).tag(hemispehere)
                    }
            }.listRowBackground(Color.acSecondaryBackground)
            Picker(selection: $appUserDefaults.fruit,
                   label: Text("Starting fruit")) {
                    ForEach(Fruit.allCases, id: \.self) { fruit in
                        HStack {
                            Image(fruit.rawValue.capitalized)
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 30, height: 30)
                            Text(LocalizedStringKey(fruit.rawValue.capitalized)).tag(fruit)
                        }
                    }
            }.listRowBackground(Color.acSecondaryBackground)
            
            Picker(selection: $appUserDefaults.nookShop,
                   label: Text("Nook shop")) {
                    ForEach(Infrastructure.NookShop.allCases, id: \.self) { shop in
                        Text(LocalizedStringKey(shop.rawValue)).tag(shop)
                    }
            }.listRowBackground(Color.acSecondaryBackground)
            
            Picker(selection: $appUserDefaults.ableSisters,
                   label: Text("Able sisters")) {
                    ForEach(Infrastructure.AbleSisters.allCases, id: \.self) { sisters in
                        Text(LocalizedStringKey(sisters.rawValue.capitalized)).tag(sisters)
                    }
            }.listRowBackground(Color.acSecondaryBackground)
            
            Picker(selection: $appUserDefaults.residentService,
                   label: Text("Residents service")) {
                    ForEach(Infrastructure.ResidentService.allCases, id: \.self) { service in
                        Text(LocalizedStringKey(service.rawValue.capitalized)).tag(service)
                    }
            }.listRowBackground(Color.acSecondaryBackground)
        }
    }
    
    private var appSection: some View {
        Section(header: SectionHeaderView(text: "App Settings", icon: "bag")) {
            /*
            if UIApplication.shared.supportsAlternateIcons && UIDevice.current.userInterfaceIdiom != .pad {
                NavigationLink(destination: AppIconPickerView()) {
                    Text("App Icon")
                }
            }
             */
            Button(action: {
                self.subscriptionManager.restorePurchase()
            }) {
                if self.subscriptionManager.subscriptionStatus == .subscribed {
                    Text("You're subscribed to AC Helper+")
                        .foregroundColor(.acSecondaryText)
                } else {
                    Text("Restore purchase")
                        .foregroundColor(.acHeaderBackground)
                }
            }
            .disabled(subscriptionManager.inPaymentProgress)
            .opacity(subscriptionManager.inPaymentProgress ? 0.5 : 1.0)
            .listRowBackground(Color.acSecondaryBackground)
        }
    }
    
    private var dataSection: some View {
        Section(header: SectionHeaderView(text: "My data", icon: "tray.and.arrow.up.fill")) {
            HStack {
                Text("Collection size")
                Spacer()
                Text(collection.sizeOfArchivedState())
                    .font(.footnote)
                    .foregroundColor(.acSecondaryText)
            }.listRowBackground(Color.acSecondaryBackground)
            
            HStack {
                Text("Using iCloud sync")
                Spacer()
                Image(systemName: collection.isCloudEnabled ? "icloud.fill" : "icloud.slash")
                    .foregroundColor(collection.isCloudEnabled ? .acTabBarBackground : .red)
                
            }.listRowBackground(Color.acSecondaryBackground)
            
            if collection.isCloudEnabled {
                HStack {
                    Text("Synchronized with iCloud")
                    Spacer()
                    if !collection.isSynched {
                        ProgressView()
                    } else {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.acTabBarBackground)
                    }
                }.listRowBackground(Color.acSecondaryBackground)
            }
            
            Button(action: {
                if collection.generateExportURL() != nil {
                    isExporting = true
                }
            }) {
                Text("Export my collection").foregroundColor(.acHeaderBackground)
            }.listRowBackground(Color.acSecondaryBackground)
            
            Button(action: {
                isImporting = true
            }) {
                Text("Import a collection").foregroundColor(.acHeaderBackground)
            }
            .listRowBackground(Color.acSecondaryBackground)
            .alert(isPresented: $showSuccessImportAlert,
                    content: { self.importSuccessAlert })
            
            Button(action: {
                self.showDeleteConfirmationAlert = true
            }) {
                Text("Reset my collection").foregroundColor(.red)
            }
            .listRowBackground(Color.acSecondaryBackground)
            .alert(isPresented: $showDeleteConfirmationAlert,
                    content: { self.deleteConfirmationAlert })
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SubscriptionManager.shared)
            .environmentObject(UserCollection.shared)
    }
}
