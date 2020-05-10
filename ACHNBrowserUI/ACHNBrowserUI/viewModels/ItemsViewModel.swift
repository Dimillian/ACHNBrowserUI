//
//  ItemsViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import Backend

class ItemsViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var sortedItems: [Item] = []
    @Published var searchItems: [Item] = []
    @Published var searchText = ""
    
    public let category: Backend.Category
    
    private var itemCancellable: AnyCancellable?
    private var searchCancellable: AnyCancellable?
    
    enum Sort: String, CaseIterable {
        case name, buy, sell, set, similar
    }
        
    var sort: Sort? {
        didSet {
            guard let sort = sort else { return }
            switch sort {
            case .name:
                let compare: (String, String) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = items.sorted{ compare($0.name, $1.name) }
            case .buy:
                let compare: (Int, Int) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = items.filter{ $0.buy != nil}.sorted{ compare($0.buy!, $1.buy!) }
            case .sell:
                let compare: (Int, Int) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = items.filter{ $0.sell != nil}.sorted{ compare($0.sell!, $1.sell!) }
            case .set:
                let compare: (String, String) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = items.filter{ $0.set != nil}.sorted{ compare($0.set!, $1.set!) }
            case .similar:
                let compare: (String, String) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = items.filter{ $0.tag != nil}.sorted{ compare($0.tag!, $1.tag!) }
            }
        }
    }
        
    public init(category: Backend.Category) {
        self.category = category

        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map(items(with:))
            .sink{ [weak self] in
                self?.searchItems = $0
        }

        itemCancellable = Items.shared.$categories
            .sink { [weak self] in
            self?.items = $0[category]?.sorted{ $0.name < $1.name } ?? []
        }
    }

    private func items(with string: String) -> [Item] {
        items.filter {
            $0.name.lowercased().contains(string.lowercased())
        }
    }
}
