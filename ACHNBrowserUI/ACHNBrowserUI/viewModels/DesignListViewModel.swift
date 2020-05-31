//
//  DesignListViewModel.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 31.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Backend
import Combine
import SwiftUI

final class DesignListViewModel: ObservableObject {

    // MARK: - Public properties

    @Published var designs: [Design] = []

    // MARK: - Private properties

    @ObservedObject private var userCollection: UserCollection
    private var cancellable: AnyCancellable?

    // MARK: - Life cycle

    init(userCollection: UserCollection = .shared) {
        self.userCollection = userCollection

        cancellable = userCollection.$designs
            .receive(on: DispatchQueue.main)
            .sink { designs in
                self.designs = designs
        }
    }

    // MARK: - Public

    func deleteDesign(at index: Int) {
        userCollection.deleteDesign(at: index)
    }
}
