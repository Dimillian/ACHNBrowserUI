//
//  CollectionViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

public class UserCollection: ObservableObject {
    public static let shared = UserCollection()
    
    @Published public var items: [Item] = []
    @Published public var villagers: [Villager] = []
    @Published public var critters: [Item] = []
    
    struct SavedData: Codable {
        let items: [Item]
        let villagers: [Villager]
        let critters: [Item]
    }
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    public init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("collection")
            if let data = try? Data(contentsOf: filePath) {
                decoder.dataDecodingStrategy = .base64
                do {
                    let savedData = try decoder.decode(SavedData.self, from: data)
                    self.items = savedData.items
                    self.villagers = savedData.villagers
                    self.critters = savedData.critters
                } catch {
                    try? FileManager.default.removeItem(at: filePath)
                }
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    public func caughtIn(list: [Item]) -> Int {
        var caught = 0
        for critter in critters {
            if list.contains(critter) {
                caught += 1
            }
        }
        for item in items {
            if list.contains(item) && !item.name.contains("(fake)") {
                caught += 1
            }
        }
        return caught
    }
    
    public func toggleItem(item: Item) -> Bool {
        let added = items.toggle(item: item)
        save()
        return added
    }
    
    public func toggleCritters(critter: Item) -> Bool {
        let added = critters.toggle(item: critter)
        save()
        return added
    }
    
    public func toggleVillager(villager: Villager) -> Bool {
        var added = false
        if villagers.contains(villager) {
            villagers.removeAll(where: { $0 == villager })
        } else {
            villagers.append(villager)
            added = true
        }
        save()
        return added
    }
    
    private func save() {
        do {
            let savedData = SavedData(items: items, villagers: villagers, critters: critters)
            let data = try encoder.encode(savedData)
            try data.write(to: filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving collection: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
}
