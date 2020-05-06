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
            .foregroundColor(.secondary)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.dialogue)
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
                    if selectedTab == .items {
                        ForEach(collection.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(displayMode: .large, item: item)
                            }
                        }
                    } else if selectedTab == .critters {
                        ForEach(collection.villagers) { villager in
                            NavigationLink(destination: VillagerDetailView(villager: villager)) {
                                VillagerRowView(villager: villager)
                            }
                        }
                    } else if selectedTab == .villagers {
                        ForEach(collection.critters) { critter in
                            NavigationLink(destination: ItemDetailView(item: critter)) {
                                ItemRowView(displayMode: .large, item: critter)
                            }
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("My Stuff"),
                                displayMode: .automatic)
            
            placeholderView
        }
    }
}

