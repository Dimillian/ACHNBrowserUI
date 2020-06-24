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
    
    var itemCancellable: AnyCancellable?

    init(item: Item) {
        self.item = item
    }
    
    func setupItems() {
        self.itemCancellable = self.$item
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self = self else { return }                
                let items = Items.shared.categories.flatMap{ $0.value }
                if let set = $0.set, set != "None" {
                    self.setItems = items.filter({ $0.set == set })
                } else {
                    self.setItems = []
                }
                if let tag = $0.tag, tag != "None" {
                    self.similarItems = items.filter({ $0.tag == tag }).map{ $0 }
                } else {
                    self.similarItems = []
                }
                if let theme = $0.themes?.filter({ $0 != "None" }).first {
                    self.thematicItems = items.filter({ $0.themes?.contains(theme) == true }).map{ $0 }
                } else {
                    self.thematicItems = []
                }
                
                if $0.appCategory != .recipes {
                    self.recipe = Items.shared.matchItemRecipe(item: $0)
                } else if let item = Items.shared.matchFinalItem(recipe: $0) {
                    self.recipe = item
                }
        }
    }
}
