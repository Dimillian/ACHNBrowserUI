//
//  ChoreListViewModel.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 30.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Backend
import Combine
import SwiftUI

final class ChoreListViewModel: ObservableObject {

    // MARK: - Public properties

    @Published var chores: [Chore] = []

    var shouldShowResetButton: Bool {
        !chores.filter { $0.isFinished == true }.isEmpty
    }

    var shouldShowDescriptionView: Bool {
        chores.isEmpty
    }

    // MARK: - Private properties

    @ObservedObject private var userCollection: UserCollection
    private var cancellable: AnyCancellable?

    // MARK: - Life cycle

    init(userCollection: UserCollection = .shared) {
        self.userCollection = userCollection

        cancellable = userCollection.$chores
            .receive(on: DispatchQueue.main)
            .sink { chores in
                self.chores = chores
        }
    }

    func toggleChore(_ chore: Chore) {
        userCollection.toggleChore(chore)
    }

    func deleteChore(at index: Int) {
        userCollection.deleteChore(at: index)
    }

    func resetChores() {
        userCollection.resetChores()
    }
}
