//
//  Collection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

class Collection: ObservableObject {
    @Published var items: [Item] = []
    
    private let filePath: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    init() {
        do {
            filePath = try FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent("collection")
            if let data = try? Data(contentsOf: filePath) {
                decoder.dataDecodingStrategy = .base64
                items = try decoder.decode([Item].self, from: data)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func toggleItem(item: Item) {
        if items.contains(item) {
            items.removeAll(where: { $0 == item })
        } else {
            items.append(item)
        }
        save()
    }
    
    private func save() {
        do {
            let data = try encoder.encode(items)
            try data.write(to: filePath, options: .atomicWrite)
        } catch let error {
            print("Error while saving collection: \(error.localizedDescription)")
        }
        encoder.dataEncodingStrategy = .base64
    }
}
