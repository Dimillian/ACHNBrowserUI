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

    var shouldShowResetChores: Bool {
        !chores.filter { $0.isFinished == true }.isEmpty
    }

    var shouldShowDescriptionView: Bool {
        chores.isEmpty
    }

    var actionSheetVisibilityDescription: String {
        isFiltering ? "Show Finished" : "Hide Finished"
    }

    // MARK: - Private properties

    @ObservedObject private var userCollection: UserCollection
    private var cancellable: AnyCancellable?
    private var unfilteredChores: [Chore] = []

    private var isFiltering: Bool = false {
        didSet { applyFilter() }
    }

    // MARK: - Life cycle

    init(userCollection: UserCollection = .shared) {
        self.userCollection = userCollection

        cancellable = userCollection.$chores
            .receive(on: DispatchQueue.main)
            .sink { unfilteredChores in
                self.unfilteredChores = unfilteredChores
                self.applyFilter()
        }
    }

    func toggleVisibility() {
        isFiltering.toggle()
    }

    func toggleChore(_ chore: Chore) {
        userCollection.toggleChore(chore)
    }

    func deleteChore(at index: Int) {
        userCollection.deleteChore(chores[index])
    }

    func resetChores() {
        userCollection.resetChores()
    }

    // MARK: - Private

    private func applyFilter() {
        if isFiltering {
            chores = unfilteredChores.filter { !$0.isFinished }
        } else {
            chores = unfilteredChores
        }
    }
}
