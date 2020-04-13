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
    @Published var sortedItems: [Item] = []
    @Published var searchItems: [Item] = []
    @Published var searchText = ""
    
    enum Sort: String, CaseIterable {
        case name, buy, sell, from, set
    }
    
    var categorie: Categories {
        didSet {
            items = []
            fetch()
        }
    }
    
    var sort: Sort? {
        didSet {
            guard let sort = sort else { return }
            switch sort {
            case .name:
                sortedItems = items.sorted(by: \.name)
            case .buy:
                sortedItems = items.filter{ $0.buy != nil}.sorted{ $0.buy! > $1.buy! }
            case .sell:
                sortedItems = items.filter{ $0.sell != nil}.sorted{ $0.sell! > $1.sell! }
            case .from:
                sortedItems = items.filter{ $0.obtainedFrom != nil}.sorted{ $0.obtainedFrom! > $1.obtainedFrom! }
            case .set:
                sortedItems = items.filter{ $0.set != nil}.sorted{ $0.set! > $1.set! }
            }
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
