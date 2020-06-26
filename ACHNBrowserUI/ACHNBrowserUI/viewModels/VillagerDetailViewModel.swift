//
//  VillagerDetailViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import Backend

public class VillagerDetailViewModel: ObservableObject {
    let villager: Villager
    @Published var villagerItems: [Item]?
    @Published var preferredItems: [Item]?
    @Published var likes: [String]?
        
    init(villager: Villager) {
        self.villager = villager
    }
    
    func fetchItems() {
        if let filename = villager.fileName {
            _ = Items.shared.matchVillagerItems(villager: filename)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] items in
                    self?.villagerItems = items
                })
            
            _ = Items.shared.matchVillagerPreferredGifts(villager: filename)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] items in
                    self?.preferredItems = items
                })
            
            self.likes = Items.shared.villagersLike.values
                .first(where: { $0.id == filename })?
                .likes
                .unique()
            
        } else {
            self.villagerItems = nil
            self.preferredItems = nil
        }
    }
}
