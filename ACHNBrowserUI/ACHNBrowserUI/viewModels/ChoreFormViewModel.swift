//
//  ChoreFormViewModel.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 29.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Backend
import Combine

class ChoreFormViewModel: ObservableObject {

    // MARK: - Public properties

    @Published var chore: Chore

    // MARK: - Private properties

    private let userCollection: UserCollection
    private let isEditing: Bool

    // MARK: - Life cycle

    init(chore: Chore?, userCollection: UserCollection = .shared) {
        self.isEditing = chore != nil
        self.chore = chore ?? Chore()
        self.userCollection = userCollection
    }

    // MARK: - Public

    func save() {
        if isEditing {
            userCollection.updateChore(chore)
        } else {
            userCollection.addChore(chore)
        }
    }
}
