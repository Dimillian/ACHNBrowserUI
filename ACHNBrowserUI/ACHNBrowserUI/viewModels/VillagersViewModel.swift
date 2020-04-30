//
//  VillagersViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import Backend

class VillagersViewModel: ObservableObject {
    @Published var villagers: [Villager] = [] {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "d/M"
            let today = formatter.string(from: Date())
            todayBirthdays = villagers.filter( { $0.birthday == today })
        }
    }
    @Published var searchResults: [Villager] = []
    @Published var searchText = ""
    @Published var todayBirthdays: [Villager] = []
    
    private var apiPublisher: AnyPublisher<[String: Villager], Never>?
    private var searchCancellable: AnyCancellable?
    private var apiCancellable: AnyCancellable? {
        willSet {
            apiCancellable?.cancel()
        }
    }
    
    init() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map(villagers(with:))
            .sink(receiveValue: { [weak self] in self?.searchResults = $0 })
    }
    
    func fetch() {
        apiPublisher = ACNHApiService.fetch(endpoint: .villagers)
            .replaceError(with: [:])
            .eraseToAnyPublisher()
        apiCancellable = apiPublisher?
            .map{ $0.map{ $0.1}.sorted(by: { $0.id > $1.id }) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.villagers, on: self)
    }

    private func villagers(with string: String) -> [Villager] {
        villagers.filter {
            $0.name["name-en"]?.lowercased().contains(string.lowercased()) == true
        }
    }
}

