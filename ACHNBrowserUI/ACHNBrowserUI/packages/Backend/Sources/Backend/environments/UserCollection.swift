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
    @Published public var lists: [UserList] = []
    
    struct SavedData: Codable {
        let items: [Item]
        let villagers: [Villager]
        let critters: [Item]
        let lists: [UserList]?
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
                    self.lists = savedData.lists ?? []
                } catch {
                    try? FileManager.default.removeItem(at: filePath)
                }
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    public func itemsIn(category: Category) -> Int {
        let items = Items.shared.categories[category] ?? []
        var caught = self.critters.count(where: { items.contains($0) } )
        caught += self.items.count(where: { items.contains($0) && $0.name.contains("(fake)") })
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
    
    // MARK: - User items list
    public func addList(userList: UserList) {
        lists.append(userList)
        save()
    }
    
    public func editList(userList: UserList) {
        let index = lists.firstIndex(where: { $0.id == userList.id} )!
        lists[index] = userList
        save()
    }
    
    public func deleteList(at index: Int) {
        lists.remove(at: index)
        save()
    }
    
    public func addItems(for list: UUID, items: [Item]) {
        let index = lists.firstIndex(where: { $0.id == list })!
        lists[index].items.append(contentsOf: items)
        save()
    }
    
    public func deleteItem(for list: UUID, at: Int) {
        let index = lists.firstIndex(where: { $0.id == list })!
        lists[index].items.remove(at: at)
        save()
    }
    
    // MARK: - Saving
    private func save() {
        do {
            let savedData = SavedData(items: items, villagers: villagers, critters: critters, lists: lists)
            let data = try encoder.encode(savedData)
            try data.write(to: filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving collection: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
}
