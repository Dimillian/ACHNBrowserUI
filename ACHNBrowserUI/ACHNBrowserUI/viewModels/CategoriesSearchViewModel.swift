//
//  CategoriesSearchViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 24/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class CategoriesSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [Categories: [Item]] = [:]
    
    private var searchCancellable: AnyCancellable?
    
    init() {
        searchCancellable = _searchText
            .projectedValue
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map(itemsInCategories(with:))
            .assign(to: \.searchResults, on: self)
    }
    
    private func itemsInCategories(with string: String) -> [Categories: [Item]] {
        var results: [Categories: [Item]] = [:]
        Items.shared.categories.forEach {
            let items = $1.filter {
                $0.name.lowercased().contains(string.lowercased()) == true
            }.prefix(5).compactMap{ $0 }
            if !items.isEmpty {
                results[$0] = items
            }
        }
        return results
    }
}
