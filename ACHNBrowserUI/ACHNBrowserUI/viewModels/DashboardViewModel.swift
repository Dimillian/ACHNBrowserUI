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
            
    private var listingCancellable: AnyCancellable?
    private var islandCancellable: AnyCancellable?
        
    func fetchListings() {
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
