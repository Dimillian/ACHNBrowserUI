//
//  TabbarView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TabbarView: View {
    @EnvironmentObject private var uiState: UIState

    var body: some View {
        TabView(selection: $uiState.selectedTab) {

            TodayView()
                .tag(UIState.Tab.dashboard)
                .tabItem {
                    Image("icon-bells")
                    Text("Dashboard")
            }

            CategoriesView(categories: Category.items())
                .tag(UIState.Tab.items)
                .tabItem {
                    Image("icon-leaf")
                    Text("Catalog")
            }

            TurnipsView()
                .tag(UIState.Tab.turnips)
                .tabItem {
                    Image("icon-turnip")
                    Text("Turnips")
            }

            VillagersListView()
                .environmentObject(UserCollection.shared)
                .tag(UIState.Tab.villagers)
                .tabItem {
                    Image("icon-villager")
                    Text("Villagers")
            }

            CollectionListView()
                .tag(UIState.Tab.collection)
                .tabItem {
                    Image("icon-cardboard")
                    Text("Collection")
            }

        }
        .accentColor(Color.white)
    }
}
