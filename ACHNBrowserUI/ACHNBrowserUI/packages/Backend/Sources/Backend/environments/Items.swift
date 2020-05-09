//
//  Items.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

public class Items: ObservableObject {
    public static let shared = Items()
    
    @Published public var categories: [Category: [Item]] = [:]
    @Published public var villagersHouse: [String: VillagerHouse] = [:]
    
    private var villagerItemsCache: [String: [Item]] = [:]
        
    init() {
        for category in Category.allCases {
            _ = NookPlazaAPIService
                .fetch(endpoint: category)
                .replaceError(with: ItemResponse(total: 0, results: []))
                .eraseToAnyPublisher()
                .map{ $0.results }
                .subscribe(on: DispatchQueue.global())
                .receive(on: DispatchQueue.main)
                .sink(receiveValue: { [weak self] items in self?.categories[category] = items })
        }
        _ = NookPlazaAPIService
            .fetchVillagerHouse()
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .map{ Dictionary(uniqueKeysWithValues: $0.map{ ($0.id, $0) }) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in self?.villagersHouse = items })
    }
    
    public func matchVillagerItems(villager: String) -> AnyPublisher<[Item]?, Never> {
        if let cached = villagerItemsCache[villager] {
            return Future { resolve in
                resolve(.success(cached))
            }.eraseToAnyPublisher()
        }
        if let villagerHouse = villagersHouse[villager] {
            return Future { [weak self] resolve in
                var villagerItems: [VillagerHouse.Item] = []
                if let items = villagerHouse.items {
                    villagerItems.append(contentsOf: items)
                }
                if let floor = villagerHouse.floor {
                    villagerItems.append(floor)
                }
                if let wallpaper = villagerHouse.wallaper {
                    villagerItems.append(wallpaper)
                }
                if let music = villagerHouse.music {
                    villagerItems.append(music)
                }
                
                let items = Items.shared.categories
                    .mapValues({ $0 })
                    .filter { !$0.value.isEmpty && Category.furnitures().contains($0.key) }
                    .compactMap{ $1 }
                    .flatMap{ $0 }
                var results: [Item] = []
                for item in villagerItems {
                    if let match = items.first(where: { $0.name.lowercased() == item.name.lowercased() }) {
                        results.append(match)
                    }
                }
                self?.villagerItemsCache[villager] = results
                resolve(.success(result))
            }.eraseToAnyPublisher()
        }
        
        return Future { resolve in
            resolve(.success(nil))
        }.eraseToAnyPublisher()
    }
}
