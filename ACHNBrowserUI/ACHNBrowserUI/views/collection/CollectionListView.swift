//
//  CollectionListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CollectionListView: View {
    enum Tabs: String, CaseIterable {
        case items, villagers, critters
    }

    @EnvironmentObject private var collection: UserCollection
    @State private var selectedTab: Tabs = .items
    
    private var itemsList: some View {
        List(collection.items) { item in
            NavigationLink(destination: ItemDetailView(item: item)) {
                ItemRowView(item: item)
            }
        }
    }
    
    private var villagersList: some View {
        List(collection.villagers) { villager in
            NavigationLink(destination: VillagerDetailView(villager: villager)) {
                                                            VillagerRowView(villager: villager)
            }
        }
    }
    
    private var crittersList: some View {
        List(collection.critters) { item in
            NavigationLink(destination: ItemDetailView(item: item)) {
                ItemRowView(item: item)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedTab, label: Text("")) {
                    ForEach(Tabs.allCases, id: \.self) { tab in
                        Text(tab.rawValue.capitalized)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedTab == .items {
                    itemsList
                } else if selectedTab == .villagers {
                    villagersList
                } else if selectedTab == .critters {
                    crittersList
                }
            }
            .overlay(Group {
                if (selectedTab == .items && collection.items.isEmpty) || (selectedTab == .villagers && collection.villagers.isEmpty) {
                    Text("Tap the stars to start collecting!")
                        .foregroundColor(.secondary)
                }
            })
            .background(Color.dialogue)
            .navigationBarTitle(Text("My Stuff"),
                                displayMode: .inline)
        }
    }
}
