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
import UI
import SwiftUIKit

class UIState: ObservableObject {
    public static let shared = UIState()
    
    enum Tab: Int {
        case dashboard, items, villagers, collection, turnips
    }
    
    enum Route: Identifiable {
        case dodo, news
        case item(item: Item)
        case villager(villager: Villager)
        
        static let prefix = "achelperapp"
        
        var id: String {
            switch self {
            case .item(_): return "item"
            case .villager(_): return "villager"
            case .dodo: return "dodocodes"
            case .news: return "news"
            }
        }

        @ViewBuilder
        func makeSheetView() -> some View {
            NavigationView {
                switch self {
                case let .item(item):
                    ItemDetailView(item: item)
                        .environmentObject(SubscriptionManager.shared)
                        .environmentObject(UserCollection.shared)
                case let .villager(villager):
                    VillagerDetailView(villager: villager)
                case .dodo:
                    DodoCodeListView()
                        .environmentObject(DodoCodeService.shared)
                        .environmentObject(CommentService.shared)
                case .news:
                    NewsList()
                        .environmentObject(NewsArticleService.shared)
                        .environmentObject(CommentService.shared)
                }
            }
        }
    }
    
    @Published var selectedTab = Tab.dashboard
    @Published var route: Route?
}
