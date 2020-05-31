//
//  DesignFormViewModel.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 24.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Backend

class DesignFormViewModel: ObservableObject {

    // MARK: - Properties

    @Published var design: Design
    private let userCollection: UserCollection

    // MARK: - Life cycle

    init(design: Design?, userCollection: UserCollection = .shared) {
        self.design = design ?? Design()
        self.userCollection = userCollection
    }

    // MARK: - Public

    func save() {
        userCollection.addDesign(design)
    }
}
