//
//  ItemsViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var searchItems: [Item] = []
    @Published var searchText = ""
    
    var categorie: Categories {
        didSet {
            items = []
            fetch()
        }
    }
    
    private var apiPublisher: AnyPublisher<ItemResponse, Never>?
    private var searchCancellable: AnyCancellable?
    private var apiCancellable: AnyCancellable? {
        willSet {
            apiCancellable?.cancel()
        }
    }
    
    init(categorie: Categories) {
        self.categorie = categorie
        searchCancellable = _searchText
            .projectedValue
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] string in
                if !string.isEmpty {
                    self?.searchItems = self?.items.filter({ $0.name.lowercased().contains(string.lowercased()) }) ?? []
                }
        }
    }
    
    func fetch() {
        apiPublisher = APIService.fetch(endpoint: categorie)
            .replaceError(with: ItemResponse(total: 0, results: []))
            .eraseToAnyPublisher()
        apiCancellable = apiPublisher?
            .map{ $0.results }
            .receive(on: DispatchQueue.main)
            .assign(to: \.items, on: self)
    }
}
