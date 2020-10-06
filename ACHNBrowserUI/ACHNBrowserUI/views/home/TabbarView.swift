//
//  TabbarView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import Combine

struct TabbarView: View {
    @EnvironmentObject private var uiState: UIState
    @ObservedObject private var viewModel = TabbarViewModel(musicPlayerManager: MusicPlayerManager.shared)

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $uiState.selectedTab) {
                TodayView()
                    .tabItem {
                        Image("icon-bells-tabbar")
                        Text("Dashboard")
                }
                .tag(UIState.Tab.dashboard)
                
                CategoriesView(categories: Category.items())
                    .tabItem {
                        Image("icon-leaf-tabbar")
                        Text("Catalog")
                }
                .tag(UIState.Tab.items)
    
                TurnipsView()
                    .tabItem {
                        Image("icon-turnip-tabbar")
                        Text("Turnips")
                }
                .tag(UIState.Tab.turnips)
                
                VillagersListView()
                    .environmentObject(UserCollection.shared)
                    .tabItem {
                        Image("icon-villager-tabbar")
                        Text("Villagers")
                }
                .tag(UIState.Tab.villagers)
                
                CollectionListView()
                    .tabItem {
                        Image("icon-cardboard-tabbar")
                        Text("Collection")
                }
                .tag(UIState.Tab.collection)
            }
            .environment(\.currentDate, viewModel.currentDate)
            .onAppear {
                viewModel.updateCurrentDateOnTabChange(selectedTabPublisher: uiState.$selectedTab)
            }
            
            if viewModel.showPlayerView {
                PlayerView()
            }
        }
    }
}
