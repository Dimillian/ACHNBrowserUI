//
//  DashboardViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import Backend

class DashboardViewModel: ObservableObject {
    @Published var recentListings: [Listing]?
    @Published var island: Island?
    
    @Published var fishes: [Item] = []
    @Published var bugs: [Item] = []
    @Published var fossils: [Item] = []
        
    private var listingCancellable: AnyCancellable?
    private var islandCancellable: AnyCancellable?
    private var itemsCancellable: AnyCancellable?
    
    init() {
        itemsCancellable = Items.shared.$categories.sink { [weak self] items in
            self?.fishes = items[.fish] ?? []
            self?.bugs = items[.bugs] ?? []
            self?.fossils = items[.fossils] ?? []
        }
        fetchIsland()
        fetchListings()
    }
    
    private func fetchListings() {
        listingCancellable = NookazonService
            .recentListings()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] listings in
                self?.recentListings = listings
        }
    }
    
    private func fetchIsland() {
        /*
        islandCancellable = TurnipExchangeService.shared
            .fetchIslands()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] islands in
                self?.island = islands.first
            })
        */
    }
    
}
