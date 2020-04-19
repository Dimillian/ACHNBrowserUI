//
//  Items.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

class Items: ObservableObject {
    static let shared = Items()
    
    @Published var categories: [Categories: [Item]] = [:]
    
    private var cancellable: [AnyCancellable] = []
    
    init() {
        for categorie in Categories.allCases {
            cancellable.append(NookPlazaAPIService.fetch(endpoint: categorie)
                .replaceError(with: ItemResponse(total: 0, results: []))
                .eraseToAnyPublisher()
                .map{ $0.results }
                .receive(on: DispatchQueue.main).sink { [weak self] items in
                    self?.categories[categorie] =  items
            })
        }
    }
}
