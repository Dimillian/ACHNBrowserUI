//
//  TabbarView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TabbarView: View {
    enum Tab: Int {
        case dashboard, items, villagers, collection, turnips
    }
    
    @State var selectedTab = Tab.dashboard
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(image)
            Text(text)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                DashboardView().tabItem{
                    self.tabbarItem(text: "Dashboard", image: "icon-bells")
                }.tag(Tab.dashboard)
                CategoriesView(categories: Category.items()).tabItem{
                    self.tabbarItem(text: "Catalog", image: "icon-leaf")
                }.tag(Tab.items)
                TurnipsView().tabItem {
                    tabbarItem(text: "Turnips", image: "icon-turnip")
                }.tag(Tab.turnips)
                VillagersListView().tabItem{
                    self.tabbarItem(text: "Villagers", image: "icon-villager")
                }.tag(Tab.villagers)
                CollectionListView().tabItem{
                    self.tabbarItem(text: "My Stuff", image: "icon-cardboard")
                }.tag(Tab.collection)
            }
        }.accentColor(.white)
    }
}
