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

    // MARK: - Public properties

    @Published var villagers: [Villager] = []
    @Published var residents: [Villager] = []
    @Published var liked: [Villager] = []
    @Published var searchResults: [Villager] = []
    @Published var searchText = ""
    @Published var todayBirthdays: [Villager] = []
    @Published var sortedVillagers: [Villager] = []
    @Published var isLoading = false

    // MARK: - Private properties

    private var apiPublisher: AnyPublisher<[String: Villager], Never>?
    private var searchCancellable: AnyCancellable?

    private var apiCancellable: AnyCancellable? {
        willSet {
            apiCancellable?.cancel()
        }
    }
    
    private let collection: UserCollection
    private let currentDate: Date
    private var villagersCancellable: AnyCancellable?

    private var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M"
        return formatter.string(from: currentDate)
    }

    // MARK: - Life cycle
    
    init(collection: UserCollection = .shared, currentDate: Date) {
        self.collection = collection
        self.currentDate = currentDate
        
        self.villagersCancellable = Publishers.CombineLatest(collection.$villagers, collection.$residents)
            .sink { [weak self] (villagers, residents) in
                self?.residents = residents
                self?.liked = villagers
        }

        isLoading = false
        searchCancellable = $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .filter { !$0.isEmpty }
            .map { [weak self] in self?.villagers(with: $0) ?? [] }
            .sink(receiveValue: { [weak self] in self?.searchResults = $0 })

        apiPublisher = ACNHApiService.fetch(endpoint: .villagers)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: [:])
            .eraseToAnyPublisher()
        apiCancellable = apiPublisher?
            .subscribe(on: DispatchQueue.global())
            .map{ $0.map{ $0.1}.sorted(by: { $0.id > $1.id }) }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] in
                guard let self = self else { return }
                self.villagers = $0
                self.todayBirthdays = $0.filter( { $0.birthday == self.today })
                self.isLoading = false
            })
    }

    // MARK: - Private

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

