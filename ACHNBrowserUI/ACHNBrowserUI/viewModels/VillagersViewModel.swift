//
//  VillagersViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

class VillagersViewModel: ObservableObject {
    @Published var villagers: [Villager] = []
    @Published var searchResults: [Villager] = []
    @Published var searchText = ""
    
    private var apiPublisher: AnyPublisher<[String: Villager], Never>?
    private var searchCancellable: AnyCancellable?
    private var apiCancellable: AnyCancellable? {
        willSet {
            apiCancellable?.cancel()
        }
    }
    
    init() {
        searchCancellable = _searchText
            .projectedValue
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] string in
                if !string.isEmpty {
                    self?.searchResults = self?.villagers.filter({
                        $0.name["name-en"]?.lowercased().contains(string.lowercased()) == true
                    }) ?? []
                }
        }
    }
    
    func fetch() {
        apiPublisher = ACNHApiService.fetch(endpoint: .villagers)
            .replaceError(with: [:])
            .eraseToAnyPublisher()
        apiCancellable = apiPublisher?
            .map{ $0.map{ $0.1} }
            .receive(on: DispatchQueue.main)
            .assign(to: \.villagers, on: self)
    }
}

