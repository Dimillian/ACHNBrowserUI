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
    @Published var listings: [Listing] = []
    
    var cancellable: AnyCancellable?
    
    init(item: Item) {
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
