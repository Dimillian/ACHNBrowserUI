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

    // MARK: - Nested types

    enum Sort: String, CaseIterable {
        case name, buy, sell, set, similar, critterpedia

        static func allCases(for category: Backend.Category) -> [Sort] {
            allCases.filter { $0.canSort(category) }
        }

        private func canSort(_ category: Backend.Category) -> Bool {
            switch self {
            case .buy, .similar, .set:
                return ![.bugs, .fish, .seaCreatures, .fossils].contains(category)
            case .critterpedia:
                return [.bugs, .fish, .seaCreatures].contains(category)
            default:
                return true
            }
        }
    }

    // MARK: - Properties

    @Published var allItems: [Item] = []
    @Published var sortedItems: [Item] = []
    @Published var searchItems: [Item] = []
    @Published var searchText = ""

    var items: [Item] {
        if !searchText.isEmpty {
            return searchItems
        } else if sort != nil {
            return sortedItems
        } else {
            return allItems
        }
    }

    public let category: Backend.Category

    var sort: Sort? {
        didSet {
            guard let sort = sort else { return }
            switch sort {
            case .name:
                let order: ComparisonResult = sort == oldValue ? .orderedAscending : .orderedDescending
                sortedItems = allItems
                    .sorted(by: removingOccurrences(of: "-", order: order))
            case .buy:
                let compare: (Int, Int) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = allItems.filter { $0.buy != nil}.sorted { compare($0.buy!, $1.buy!) }
            case .sell:
                let compare: (Int, Int) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = allItems.filter { $0.sell != nil}.sorted { compare($0.sell!, $1.sell!) }
            case .set:
                let compare: (String, String) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = allItems.filter { $0.set != nil}.sorted { compare($0.set!, $1.set!) }
            case .similar:
                let compare: (String, String) -> Bool = sort == oldValue ? (<) : (>)
                sortedItems = allItems.filter { $0.tag != nil}.sorted { compare($0.tag!, $1.tag!) }
            case .critterpedia:
                let compare: (Int, Int) -> Bool = sort == oldValue ? (>) : (<)
                sortedItems = allItems
                    .filter { $0.critterId != nil}
                    .sorted{ compare($0.critterId!, $1.critterId!) }
            }
        }
    }

    private var itemCancellable: AnyCancellable?
    private var searchCancellable: AnyCancellable?
    private static var META_KEYWORD_CACHE: [String: [Item]] = [:]

    // MARK: - Life cycle

    public init(category: Backend.Category, items allItems: [Item]) {
        self.category = category
        self.allItems = allItems
        setUpSearch()
    }
    
    public init(category: Backend.Category) {
        self.category = category
        setUpSearch()
        
        itemCancellable = Items.shared.$categories
            .subscribe(on: DispatchQueue.global())
            .map{ $0[category]?.sorted{ $0.localizedName.localizedCompare($1.localizedName) == .orderedAscending } ?? [] }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.allItems = $0
        }
    }
    
    public init(meta: String) {
        self.category = .other
        if let items = Self.META_KEYWORD_CACHE[meta] {
            self.allItems = items
        } else {
            itemCancellable = Items.shared.$categories
                .subscribe(on: DispatchQueue.global())
                .map{ $0.values.flatMap{ $0 }.filter({ $0.metas.contains(meta) }) }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] allItems in
                    Self.META_KEYWORD_CACHE[meta] = allItems
                    self?.allItems = allItems
            }
        }
        setUpSearch()
    }

    // MARK: - Private

    private func items(with string: String) -> [Item] {
        allItems.filter {
            $0.localizedName.lowercased().contains(string.lowercased())
        }
        .sorted(by: removingOccurrences(of: "-", order: .orderedAscending))
    }

    private func setUpSearch() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map(items(with:))
            .sink{ [weak self] in
                self?.searchItems = $0
        }
    }

    private func removingOccurrences(of string: String, order: ComparisonResult) -> (Item, Item) -> Bool {
        {
            let first = $0.localizedName.replacingOccurrences(of: string, with: " ")
            let second = $1.localizedName.replacingOccurrences(of: string, with: " ")
            return first.localizedCompare(second) == order
        }
    }
}
