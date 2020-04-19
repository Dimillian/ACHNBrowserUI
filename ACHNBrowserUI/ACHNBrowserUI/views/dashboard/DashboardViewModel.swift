//
//  DashboardViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

class DashboardViewModel: ObservableObject {
    @Published var recentListings: [Listing]?
    @Published var island: Island?
    
    @Published var fishes: [Item] = []
    @Published var bugs: [Item] = []
    @Published var fossils: [Item] = []
    
    var listingCancellable: AnyCancellable?
    var islandCancellable: AnyCancellable?
    
    var bugsApiCancellable: AnyCancellable?
    var fishesApiCancellable: AnyCancellable?
    var fossilsApiCancellable: AnyCancellable?
    
    func fetchListings() {
        listingCancellable = NookazonService
            .recentListings()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] listings in
                self?.recentListings = listings
        }
    }
    
    func fetchIsland() {
        islandCancellable = TurnipExchangeService.shared
            .fetchIslands()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] islands in
                self?.island = islands.first
        }
    }
    
    private func processPublisher(publisher: AnyPublisher<ItemResponse, APIError>,
                                  keypath: ReferenceWritableKeyPath<DashboardViewModel, [Item]>) -> AnyCancellable {
        return publisher.replaceError(with: ItemResponse(total: 0, results: []))
            .eraseToAnyPublisher()
            .map{ $0.results }
            .receive(on: DispatchQueue.main)
            .assign(to: keypath, on: self)
    }
    
    func fetchCritters() {
        bugsApiCancellable = processPublisher(publisher:NookPlazaAPIService.fetch(endpoint: Categories.bugs()),
                                              keypath: \.bugs)
        fishesApiCancellable = processPublisher(publisher: NookPlazaAPIService.fetch(endpoint: Categories.fish()),
                                                 keypath: \.fishes)
        fossilsApiCancellable = processPublisher(publisher: NookPlazaAPIService.fetch(endpoint: .fossils),
                                                 keypath: \.fossils)
    }
}
