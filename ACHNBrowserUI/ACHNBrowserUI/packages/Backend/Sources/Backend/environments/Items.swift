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
    }
}
