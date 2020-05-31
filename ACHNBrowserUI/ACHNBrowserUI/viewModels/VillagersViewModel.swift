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
    private static var cachedVillagers: [Villager] = []
    
    @Published var villagers: [Villager] = []
    @Published var searchResults: [Villager] = []
    @Published var searchText = ""
    @Published var todayBirthdays: [Villager] = []
    @Published var sortedVillagers: [Villager] = []

    private var apiPublisher: AnyPublisher<[String: Villager], Never>?
    private var searchCancellable: AnyCancellable?
    private var apiCancellable: AnyCancellable? {
        willSet {
            apiCancellable?.cancel()
        }
    }
    
    private var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M"
        return formatter.string(from: Date())
    }
    
    init() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map(villagers(with:))
            .sink(receiveValue: { [weak self] in self?.searchResults = $0 })
        
        if villagers.isEmpty {
            villagers = Self.cachedVillagers
            todayBirthdays = villagers.filter( { $0.birthday == today } )
        }
        if !villagers.isEmpty {
            return
        }
        apiPublisher = ACNHApiService.fetch(endpoint: .villagers)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: [:])
            .eraseToAnyPublisher()
        apiCancellable = apiPublisher?
            .subscribe(on: DispatchQueue.global())
            .map{ $0.map{ $0.1}.sorted(by: { $0.id > $1.id }) }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                Self.cachedVillagers = $0
                self?.villagers = $0
                self?.todayBirthdays = $0.filter( { $0.birthday == self?.today })
            })
    }
    
    private func villagers(with string: String) -> [Villager] {
        villagers.filter {
            $0.localizedName.lowercased().contains(string.lowercased()) == true
        }
    }
    
    // MARK: - Sort
    
    enum Sort: String, CaseIterable {
        case name, species, personality
    }
        
    var sort: Sort? {
        didSet {
            guard let sort = sort else {
                sortedVillagers = []
                return
            }

            let order: ComparisonResult = sort == oldValue ? .orderedDescending : .orderedAscending

            switch sort {
            case .name:
                sortedVillagers = villagers.sortedByLocalizedString(using: \Villager.localizedName, direction: order)
            case .species:
                sortedVillagers = villagers.sortedByLocalizedString(using: \Villager.species, direction: order)
            case .personality:
                sortedVillagers = villagers.sortedByLocalizedString(using: \Villager.personality, direction: order)
            }
        }
    }
}

