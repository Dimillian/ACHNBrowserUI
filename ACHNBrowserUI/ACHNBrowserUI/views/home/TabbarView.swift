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
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(image)
            Text(text)
        }
    }
    
    var body: some View {
        TabView(selection: $uiState.selectedTab) {
            Group {
                DashboardView().tabItem{
                    self.tabbarItem(text: NSLocalizedString("Dashboard", comment: ""), image: "icon-bells")
                }.tag(UIState.Tab.dashboard)
                CategoriesView(categories: Category.items()).tabItem{
                    self.tabbarItem(text: NSLocalizedString("Catalog", comment: ""), image: "icon-leaf")
                }.tag(UIState.Tab.items)
                TurnipsView().tabItem {
                    tabbarItem(text: NSLocalizedString("Turnips", comment: ""), image: "icon-turnip")
                }.tag(UIState.Tab.turnips)
                VillagersListView().environmentObject(UserCollection.shared).tabItem{
                    self.tabbarItem(text: NSLocalizedString("Villagers", comment: ""), image: "icon-villager")
                }.tag(UIState.Tab.villagers)
                CollectionListView().tabItem{
                    self.tabbarItem(text: NSLocalizedString("My Stuff", comment: ""), image: "icon-cardboard")
                }.tag(UIState.Tab.collection)
            }
        }.accentColor(.white)
    }
}
