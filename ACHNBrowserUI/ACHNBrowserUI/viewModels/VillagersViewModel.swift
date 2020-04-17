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
    
    private var apiPublisher: AnyPublisher<[String: Villager], Never>?
    private var searchCancellable: AnyCancellable?
    private var apiCancellable: AnyCancellable? {
        willSet {
            apiCancellable?.cancel()
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

