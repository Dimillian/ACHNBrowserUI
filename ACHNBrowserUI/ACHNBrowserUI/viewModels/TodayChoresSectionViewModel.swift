//
//  TodayChoresSectionViewModel.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 30.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Backend
import Combine
import SwiftUI

final class TodayChoresSectionViewModel: ObservableObject {

    // MARK: - Public properties

    @Published var chores: [Chore] = []

    var totalChoresCount: Int {
        chores.count
    }

    var completeChoresCount: Int {
        chores.filter { $0.isFinished == true }.count
    }

    // MARK: - Private properties

    @ObservedObject private var userCollection: UserCollection
    private var cancellable: AnyCancellable?

    // MARK: - Life cycle

    init(userCollection: UserCollection = .shared) {
        self.userCollection = userCollection

        cancellable = self.userCollection.$chores
            .receive(on: DispatchQueue.main)
            .sink { chores in
                self.chores = chores
        }
    }
}
