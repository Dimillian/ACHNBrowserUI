//
//  DreamCodeListView.swift
//  ACHNBrowserUI
//
//  Created by Jan van Heesch on 02.08.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Backend
import SwiftUIKit

struct DreamCodeListView: View {
    @EnvironmentObject private var service: DreamCodeService
    
    @State private var sheet: Sheet.SheetType?
    @State private var showiCloudAlert = false
    
    var body: some View {
        List {
            Section(header: SectionHeaderView(text: "Notifications", icon: "bell.fill")) {
                Toggle(isOn: Binding<Bool>(
                    get: { AppUserDefaults.shared.dreamNotifications },
                    set: {
                        AppUserDefaults.shared.dreamNotifications = $0
                        if !$0 {
                            self.service.disableNotifications()
                        } else {
                            self.service.enableNotifications()
                        }
                })) {
                    Text("Get notified of new dream codes")
                        .foregroundColor(.acText)
                }
            }.listRowBackground(Color.acSecondaryBackground)
            
            Section {
                Picker(selection: $service.sort, label: Text("Sort")) {
                    ForEach(DreamCodeService.Sort.allCases, id: \.self) { sort in
                        Text(LocalizedStringKey(sort.rawValue)).tag(sort)
                    }
                }
            }.listRowBackground(Color.acSecondaryBackground)
            
            Group {
                if service.isSynching && service.codes.isEmpty {
                    RowLoadingView()
                } else if !service.codes.isEmpty {
                    ForEach(service.codes) { code in
                        Section(header: SectionHeaderView(text: code.islandName, icon: "moon.zzz")) {
                            NavigationLink(destination: DreamCodeDetailView(code: code)) {
                                DreamCodeRow(code: code, showButtons: true)
                            }
                        }
                    }
                } else {
                    Text("No dream codes available yet, add your own to let other players visit your island in their dreams")
                        .foregroundColor(.acSecondaryText)
                }
            }.listRowBackground(Color.acSecondaryBackground)
        }
        .listStyle(InsetGroupedListStyle())
        .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
        .alert(isPresented: $showiCloudAlert, content: { self.iCloudAlert })
        .navigationBarTitle("Dream codes")
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
              message: Text("You need an iCloud account to add your dream code"),
              dismissButton: .default(Text("Ok")))
    }
    
    private var addButton: some View {
        Button(action: {
            if !self.service.canAddCode {
                self.showiCloudAlert = true
                return
            }
            self.sheet = .dreamCodeForm(editing: nil)
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
                ProgressView()
            } else {
                Image(systemName: "arrow.counterclockwise.circle").imageScale(.large)
            }
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
    }
}
