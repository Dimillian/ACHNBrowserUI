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
        case items, wardrobe, nature, villagers, collection, turnips
    }
    
    @State var selectedTab = Tab.items
    
    func tabbarItem(text: String, image: String) -> some View {
        VStack {
            Image(image)
            Text(text)
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Group {
                CategoriesView(categories: Categories.items()).tabItem{
                    self.tabbarItem(text: "Catalog", image: "icon-leaf")
                }.tag(Tab.items)
//                ItemsListView(categories: Categories.wardrobe()).tabItem{
//                    self.tabbarItem(text: "Wardrobe", image: "icon-top")
//                }.tag(Tab.wardrobe)
//                ItemsListView(categories: Categories.nature()).tabItem{
//                    self.tabbarItem(text: "Nature", image: "icon-fossil")
//                }.tag(Tab.nature)
                TurnipsView().tabItem {
                    tabbarItem(text: "Turnips", image: "icon-turnip")
                }.tag(Tab.turnips)
                VillagersListView().tabItem{
                    self.tabbarItem(text: "Villagers", image: "icon-villager")
                }.tag(Tab.villagers)
                CollectionListView().tabItem{
                    self.tabbarItem(text: "Collection", image: "icon-cardboard")
                }.tag(Tab.collection)
            }
        }.accentColor(.white)
    }
}
