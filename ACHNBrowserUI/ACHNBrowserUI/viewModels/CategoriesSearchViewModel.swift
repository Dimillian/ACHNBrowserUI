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
    @Published var searchResults: [Category: [Item]] = [:]
    
    private var searchCancellable: AnyCancellable?
    
    init() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map(itemsInCategory(with:))
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in self?.searchResults = $0})
    }

    private func itemsInCategory(with string: String) -> [Category: [Item]] {
        Items.shared.categories
            .mapValues({ $0.filter({
                $0.name.lowercased().contains(string.lowercased())
            }) })
            .filter { !$0.value.isEmpty }
            .mapValues { Array($0.prefix(5)) }
    }
}
