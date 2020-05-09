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
    
    init(villager: Villager) {
        self.villager = villager
        
        if let filename = villager.fileName {
            _ = Items.shared.matchVillagerItems(villager: filename)
                .subscribe(on: DispatchQueue.global(qos: .userInitiated))
                .receive(on: DispatchQueue.main)
                .map({ $0 })
                .sink(receiveValue: { [weak self] items in
                    self?.villagerItems = items
                })
            
        } else {
            self.villagerItems = nil
        }
    }
}
