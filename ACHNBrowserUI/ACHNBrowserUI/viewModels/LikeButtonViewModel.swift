//
//  LikeButtonViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 02/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Backend

class LikeButtonViewModel: ObservableObject {
    
    let item: Item?
    let variant: Variant?
    let villager: Villager?
    
    @Published var isInCollection = false
    
    private let collection: UserCollection
    
    init(item: Item? = nil, variant: Variant? = nil, villager: Villager? = nil, collection: UserCollection = .shared) {
        self.item = item
        self.variant = variant
        self.villager = villager
        self.collection = collection
        self.isInCollection = computeIsInCollection()
    }
        
    private func computeIsInCollection() -> Bool {
        if let item = item {
            if let variant = variant {
                return collection.variantIn(item: item, variant: variant)
            }
            return collection.items.contains(item) || collection.critters.contains(item)
        } else if let villager = villager {
            return collection.villagers.contains(villager)
        }
        return false
    }
    
    func toggleCollection() -> Bool {
        var added = false
        if let item = self.item {
            switch item.appCategory {
            case .fish, .bugs, .fossils:
                added = self.collection.toggleCritters(critter: item)
            default:
                if let variant = self.variant {
                    added = self.collection.toggleVariant(item: item, variant: variant)
                }
                added = self.collection.toggleItem(item: item)
            }
        } else if let villager = self.villager {
            added = self.collection.toggleVillager(villager: villager)
        }
        isInCollection = computeIsInCollection()
        return added
    }
}
