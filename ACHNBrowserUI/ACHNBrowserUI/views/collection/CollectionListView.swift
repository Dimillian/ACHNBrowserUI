//
//  CollectionListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

enum Tabs: String, CaseIterable {
    case items, villagers, critters, lists
}

struct CollectionListView: View {
    @EnvironmentObject private var collection: UserCollection
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @State private var selectedTab: Tabs = .items
    @State private var sheet: Sheet.SheetType?
        
    var body: some View {
        NavigationView {
            List {
                Section(header: picker) {
                    if selectedTab == .items && !collection.items.isEmpty {
                        ForEach(collection.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(displayMode: .large, item: item)
                            }
                        }
                    } else if selectedTab == .villagers && !collection.villagers.isEmpty {
                        ForEach(collection.villagers) { villager in
                            NavigationLink(destination: VillagerDetailView(villager: villager)) {
                                VillagerRowView(villager: villager)
                            }
                        }
                    } else if selectedTab == .critters && !collection.critters.isEmpty {
                        ForEach(collection.critters) { critter in
                            NavigationLink(destination: ItemDetailView(item: critter)) {
                                ItemRowView(displayMode: .large, item: critter)
                            }
                        }
                    } else if selectedTab == .lists {
                        userListsSections
                    }  else {
                        emptyView
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("My Stuff"),
                                displayMode: .automatic)
            .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
            
            if collection.items.isEmpty {
                placeholderView
            } else {
                ItemDetailView(item: collection.items.first!)
            }
        }
    }
    
    private var userListsSections: some View {
        Group {
            if subscriptionManager.subscriptionStatus == .subscribed || collection.lists.isEmpty {
                Button(action: {
                    self.sheet = .userListForm(editingList: nil)
                }) {
                    Text("Create a new list").foregroundColor(.acHeaderBackground)
                }
            }
            ForEach(collection.lists) { list in
                NavigationLink(destination: UserListDetailView(list: list)) {
                    UserListRow(list: list)
                }
            }.onDelete { indexes in
                self.collection.deleteList(at: indexes.first!)
            }
            if subscriptionManager.subscriptionStatus != .subscribed && collection.lists.count >= 1 {
                UserListSubscribeCallView(sheet: $sheet)
            }
        }
    }
    
    private var placeholderView: some View {
        Text("Please select or go stars some items!")
            .foregroundColor(.acSecondaryText)
    }
    
    private var emptyView: some View {
        Text("When you'll stars some \(selectedTab.rawValue), they'll be displayed here.")
            .foregroundColor(.acSecondaryText)
    }
    
    private var picker: some View {
        Picker(selection: $selectedTab, label: Text("")) {
            ForEach(Tabs.allCases, id: \.self) { tab in
                Text(tab.rawValue.capitalized)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

