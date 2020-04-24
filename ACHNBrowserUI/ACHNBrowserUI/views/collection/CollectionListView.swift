//
//  CollectionListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

enum Tabs: String, CaseIterable {
    case items, villagers, critters
}

struct CollectionListSections: View {
    @Binding var selectedTab: Tabs
    @EnvironmentObject private var collection: UserCollection

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
        Group {
            if selectedTab == .items {
                itemsList
            } else if selectedTab == .villagers {
                villagersList
            } else if selectedTab == .critters {
                crittersList
            }
        }
    }
}

struct CollectionListView: View {
    @State private var selectedTab: Tabs = .items
    
    private var placeholderView: some View {
        Text("Please select or go stars some items!")
            .foregroundColor(.secondary)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.dialogue)
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
                CollectionListSections(selectedTab: $selectedTab)
            }
            .background(Color.dialogue)
            .navigationBarTitle(Text("My Stuff"),
                                displayMode: .inline)
            
            placeholderView
        }
    }
}
