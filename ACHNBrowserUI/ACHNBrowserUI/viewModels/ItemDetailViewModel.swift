//
//  ItemDetailViewModel.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/16/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import Backend

class ItemDetailViewModel: ObservableObject {
    @Published var item: Item
    @Published var recipe: Item?
    
    @Published var setItems: [Item] = []
    @Published var similarItems: [Item] = []
    @Published var thematicItems: [Item] = []
    @Published var colorsItems: [Item] = []
    
    @Published var listings: [Listing] = []
    @Published var loading: Bool = false
    
    var cancellable: AnyCancellable?
    var itemCancellable: AnyCancellable?

    init(item: Item) {
        self.item = item
    }
    
    func setupItems() {
        self.itemCancellable = self.$item
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }
                self.cancellable?.cancel()
                self.listings = []
                // self?.fetchListings()
                
                let items = Items.shared.categories.flatMap{ $0.value }
                if let set = $0.set, set != "None" {
                    self.setItems = items.filter({ $0.set == set })
                } else {
                    self.setItems = []
                }
                if let tag = $0.tag, tag != "None" {
                    self.similarItems = items.filter({ $0.tag == tag }).prefix(30).map{ $0 }
                } else {
                    self.similarItems = []
                }
                if let theme = $0.themes?.filter({ $0 != "None" }).first {
                    self.thematicItems = items.filter({ $0.themes?.contains(theme) == true }).prefix(30).map{ $0 }
                } else {
                    self.thematicItems = []
                }
                if let color = $0.colors?.first {
                    self.colorsItems = items.filter({ $0.colors?.contains(color) == true }).prefix(30).map{ $0 }
                } else {
                    self.colorsItems = []
                }
                
                if $0.appCategory != .recipes {
                    self.recipe = Items.shared.matchItemRecipe(item: $0)
                } else if let item = Items.shared.matchFinalItem(recipe: $0) {
                    self.recipe = item
                }
        }
    }
    
    private func fetchListings() {
        loading = true
        cancellable = NookazonService.fetchListings(item: item)
            .catch { _ in Just([]) }
            .receive(on: RunLoop.main)
            .sink { [weak self] listings in
                self?.loading = false
                self?.listings = listings
        }
    }
    
    deinit {
        cancellable?.cancel()
    }
}
