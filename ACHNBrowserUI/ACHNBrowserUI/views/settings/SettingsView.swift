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

struct SettingsView: View {
    @EnvironmentObject private var collection: UserCollection
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @Environment(\.presentationMode) private var presentationMode
    @ObservedObject var appUserDefaults = AppUserDefaults.shared
    
    @State private var isDocumentPickerPresented = false
    @State private var documentPickderMode: UIDocumentPickerMode = .import
    @State private var importedFile: URL?
    @State private var showSuccessImportAlert = false
    @State private var showDeleteConfirmationAlert = false

    var body: some View {
        NavigationView {
            Form {
                islandSection
                appSection
                dataSection
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle(Text("Preferences"), displayMode: .inline)
            .navigationBarItems(leading: closeButton)
            .sheet(isPresented: $isDocumentPickerPresented,
                   onDismiss: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        if let url = self.importedFile {
                            self.showSuccessImportAlert = self.collection.processImportedFile(url: url)
                        }
                    }
                   },
                   content: { DocumentPickerView(url: self.collection.generateExportURL(),
                                                 mode: self.documentPickderMode,
                                                 importedFile: self.$importedFile) })
        }.navigationViewStyle(StackNavigationViewStyle())
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
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            Picker(selection: $appUserDefaults.hemisphere,
                   label: Text("Hemisphere")) {
                    ForEach(Hemisphere.allCases, id: \.self) { hemispehere in
                        Text(LocalizedStringKey(hemispehere.rawValue.capitalized)).tag(hemispehere)
                    }
            }
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
            }
            
            Picker(selection: $appUserDefaults.nookShop,
                   label: Text("Nook shop")) {
                    ForEach(Infrastructure.NookShop.allCases, id: \.self) { shop in
                        Text(LocalizedStringKey(shop.rawValue)).tag(shop)
                    }
            }
            
            Picker(selection: $appUserDefaults.ableSisters,
                   label: Text("Able sisters")) {
                    ForEach(Infrastructure.AbleSisters.allCases, id: \.self) { sisters in
                        Text(LocalizedStringKey(sisters.rawValue.capitalized)).tag(sisters)
                    }
            }
            
            Picker(selection: $appUserDefaults.residentService,
                   label: Text("Residents service")) {
                    ForEach(Infrastructure.ResidentService.allCases, id: \.self) { service in
                        Text(LocalizedStringKey(service.rawValue.capitalized)).tag(service)
                    }
            }
        }
    }
    
    private var appSection: some View {
        Section(header: SectionHeaderView(text: "App Settings", icon: "bag")) {
            if UIApplication.shared.supportsAlternateIcons && UIDevice.current.userInterfaceIdiom != .pad {
                NavigationLink(destination: AppIconPickerView()) {
                    Text("App Icon")
                }
            }
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
            }
            Button(action: {
                self.documentPickderMode = .exportToService
                self.isDocumentPickerPresented = true
            }) {
                Text("Export my collection").foregroundColor(.acHeaderBackground)
            }
            
            Button(action: {
                self.documentPickderMode = .import
                self.isDocumentPickerPresented = true
            }) {
                Text("Import a collection").foregroundColor(.acHeaderBackground)
            }.alert(isPresented: $showSuccessImportAlert,
                    content: { self.importSuccessAlert })
            
            Button(action: {
                self.showDeleteConfirmationAlert = true
            }) {
                Text("Reset my collection").foregroundColor(.red)
            }.alert(isPresented: $showDeleteConfirmationAlert,
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
