//
//  UIState.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 02/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Backend

class UIState: ObservableObject {
    enum Tab: Int {
        case dashboard, items, villagers, collection, turnips
    }
    
    enum Route {
        case item(item: Item)
        case villager(villager: Villager)
        
        @ViewBuilder
        func makeDetailView() -> some View {
            switch self {
            case let .item(item):
                ItemDetailView(item: item)
            case let .villager(villager):
                VillagerDetailView(villager: villager)
            }
        }
    }
    
    @Published var selectedTab = Tab.dashboard
    @Published var route: Route?
    @Published var routeEnabled = false
}
