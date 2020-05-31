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

    // MARK: - Properties

    @Published var chore: Chore

    // MARK: - Life cycle

    init(chore: Chore?) {
        self.chore = chore ?? Chore()
    }

    // MARK: - Public

    func save() {
        UserCollection.shared.addChore(chore)
    }
}
