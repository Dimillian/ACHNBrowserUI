//
//  CollectionListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

enum Tabs: String, CaseIterable {
    case items, villagers, critters
}

struct CollectionListView: View {
    @EnvironmentObject private var collection: UserCollection
    @State private var selectedTab: Tabs = .items
    
    private var placeholderView: some View {
        Text("Please select or go stars some items!")
            .foregroundColor(.secondaryText)
    }
    
    private var emptyView: some View {
        Text("When you'll stars some items, critters, or villagers, they'll be displayed here.")
            .foregroundColor(.secondaryText)
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
                    } else if selectedTab == .critters && !collection.villagers.isEmpty {
                        ForEach(collection.critters) { critter in
                            NavigationLink(destination: ItemDetailView(item: critter)) {
                                ItemRowView(displayMode: .large, item: critter)
                            }
                        }
                    } else {
                        emptyView
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("My Stuff"),
                                displayMode: .automatic)
            
            if collection.items.isEmpty {
                placeholderView
            } else {
                ItemDetailView(item: collection.items.first!)
            }
        }
    }
}

