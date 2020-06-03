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
    @Published var isResident: Bool = false
    
    private let collection: UserCollection
    private var residentsCancellable: AnyCancellable?
    
    init(villager: Villager, collection: UserCollection = .shared) {
        self.villager = villager
        self.collection = collection
        
        residentsCancellable = collection.$residents.sink
            { [weak self] in
                self?.isResident = $0.contains(villager)
        }
    }
    
    func toggleResident() {
        collection.toggleResident(villager: villager)
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
            
            self.likes = Array(Set(Items.shared.villagersLike.values.first(where: { $0.id == filename })!.likes))
            
        } else {
            self.villagerItems = nil
            self.preferredItems = nil
        }
    }
}
