//
//  ItemDetailViewModel.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/16/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

class ItemDetailViewModel: ObservableObject {
    @Published var item: Item
    @Published var listings: [Listing] = []
    
    var cancellable: AnyCancellable?
    var itemCancellable: AnyCancellable?

    init(item: Item) {
        self.item = item
        self.itemCancellable = self.$item
            .receive(on: RunLoop.main)
            .sink {
                self.cancellable?.cancel()
                self.listings = []
                self.fetch(item: $0)
            }
    }
    
    func fetch(item: Item) {
        cancellable = NookazonService.fetchListings(item: item)
            .catch { _ in Just([]) }
            .receive(on: RunLoop.main)
            .sink { [weak self] listings in
                self?.listings = listings
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
