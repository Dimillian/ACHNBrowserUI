//
//  CollectionProgressRowViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 25/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import Backend

class CollectionProgressRowViewModel: ObservableObject {
    let category: Backend.Category
    
    @Published var total: Int = 0
    @Published var inCollection: Int = 0
    
    private var cancellable: AnyCancellable?
    
    init(category: Backend.Category) {
        self.category = category
        if category == .fish || category == .bugs || category == .fossils || category == .seaCreatures {
            cancellable = UserCollection.shared.$critters
                .subscribe(on: DispatchQueue.global())
                .removeDuplicates()
                .receive(on: DispatchQueue.global())
                .sink(receiveValue: { [weak self] items in
                    let inCollection = UserCollection.shared.itemsIn(category: category, items: items)
                    let total = Items.shared.categories[category]?.count ?? 0
                    self?.set(total: total, inCollection: inCollection)
            })
        } else {
            cancellable = UserCollection.shared.$items
                .subscribe(on: DispatchQueue.global())
                .removeDuplicates()
                .receive(on: DispatchQueue.global())
                .sink(receiveValue: { [weak self] items in
                    let inCollection = UserCollection.shared.itemsIn(category: category, items: items)
                    let total = Items.shared.categories[category]?.filter({ !$0.name.contains("(fake)") }).count ?? 0
                    self?.set(total: total, inCollection: inCollection)
                })
        }
    }
    
    private func set(total: Int, inCollection: Int) {
        DispatchQueue.main.async {
            if total != self.total {
                self.total = total
            }
            if inCollection != self.inCollection {
                self.inCollection = inCollection
            }
        }
    }
}
