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
    @Published var isLoadingData = false
    
    private var searchCancellable: AnyCancellable?
    
    init() {
        searchCancellable = $searchText
            .handleEvents(receiveOutput: { [weak self] _ in self?.isLoadingData = true })
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map(itemsInCategory(with:))
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.searchResults = $0
                self.isLoadingData = false
            })
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
