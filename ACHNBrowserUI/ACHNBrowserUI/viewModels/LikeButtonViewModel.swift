//
//  LikeButtonViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 02/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Backend

class LikeButtonViewModel: ObservableObject {
    
    let item: Item?
    let variant: Variant?
    let villager: Villager?
    
    @Published var isInCollection = false
    
    private let collection: UserCollection
    private var cancellable: AnyCancellable?
    
    init(item: Item? = nil,
         variant: Variant? = nil,
         villager: Villager? = nil,
         collection: UserCollection = .shared) {
        self.item = item
        self.variant = variant
        self.villager = villager
        self.collection = collection
        
        self.cancellable = Publishers.CombineLatest4(collection.$items,
                                                     collection.$critters,
                                                     collection.$variants,
                                                     collection.$villagers)
            .sink{ [weak self] items, critters, variants, villagers in
                guard let self = self else { return }
                if let item = self.item {
                    if let variant = variant {
                        self.isInCollection = variants.contains(for: item, variant: variant)
                        return
                    }
                    self.isInCollection = items.contains(item) || critters.contains(item)
                    return
                } else if let villager = villager {
                    self.isInCollection = villagers.contains(villager)
                    return
                }
                
        }
    }
        
    func toggleCollection() -> Bool {
        var added = false
        if let item = self.item {
            switch item.appCategory {
            case .fish, .bugs, .fossils, .seaCreatures:
                added = self.collection.toggleCritters(critter: item)
            default:
                if let variant = self.variant {
                    added = self.collection.toggleVariant(item: item, variant: variant)
                    return added
                }
                added = self.collection.toggleItem(item: item)
            }
        } else if let villager = self.villager {
            added = self.collection.toggleVillager(villager: villager)
        }
        return added
    }
}
