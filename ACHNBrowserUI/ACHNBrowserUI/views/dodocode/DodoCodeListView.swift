//
//  DodoCodeListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 12/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Backend
import SwiftUIKit

struct DodoCodeListView: View {
    @EnvironmentObject private var service: DodoCodeService
    
    @State private var sheet: Sheet.SheetType?
    @State private var showiCloudAlert = false
    
    var body: some View {
        List {
            Section(header: SectionHeaderView(text: "Notifications", icon: "bell.fill")) {
                Toggle(isOn: Binding<Bool>(
                    get: { AppUserDefaults.shared.dodoNotifications },
                    set: {
                        AppUserDefaults.shared.dodoNotifications = $0
                        if !$0 {
                            DodoCodeService.shared.disableNotifications()
                        } else {
                            DodoCodeService.shared.enableNotifications()
                        }
                })) {
                    Text("Get notified of new Dodo codes")
                        .foregroundColor(.acText)
                }
            }
            
            if service.isSynching && service.codes.isEmpty {
                RowLoadingView(isLoading: .constant(true))
            } else if !service.codes.isEmpty {
                ForEach(service.codes) { code in
                    Section(header: SectionHeaderView(text: code.islandName, icon: "sun.haze.fill")) {
                        NavigationLink(destination: DodoCodeDetailView(code: code)) {
                            DodoCodeRow(code: code, showButtons: true)
                        }
                    }
                }
            } else {
                Text("No active Dodo code yet, open your island to visitors by adding your own")
                    .foregroundColor(.acSecondaryText)
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
        .alert(isPresented: $showiCloudAlert, content: { self.iCloudAlert })
        .navigationBarTitle("Dodo codes")
        .navigationBarItems(trailing:
            HStack(spacing: 8) {
                refreshButton
                addButton
            }
        )
        .onAppear(perform: service.refresh)
    }
    
    private var iCloudAlert: Alert {
        Alert(title: Text("iCloud not enabled"),
              message: Text("You need an iCloud account to add your Dodo code"),
              dismissButton: .default(Text("Ok")))
    }
    
    private var addButton: some View {
        Button(action: {
            if !self.service.canEdit {
                self.showiCloudAlert = true
                return
            }
            self.sheet = .dodoCodeForm(editing: nil)
        }) {
            Image(systemName: "plus.circle").imageScale(.large)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
    }
    
    private var refreshButton: some View {
        Button(action: {
            self.service.refresh()
        }) {
            if service.isSynching {
                ActivityIndicator(isAnimating: .constant(true), style: .medium)
            } else {
                Image(systemName: "arrow.counterclockwise.circle").imageScale(.large)
            }
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
    }
}
