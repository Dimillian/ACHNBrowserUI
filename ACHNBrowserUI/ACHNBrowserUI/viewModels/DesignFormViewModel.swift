//
//  DesignFormViewModel.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 24.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Backend

final class DesignFormViewModel: ObservableObject {

    // MARK: - Public properties

    @Published var design: Design

    // MARK: - Private properties

    private let userCollection: UserCollection
    private let isEditing: Bool

    // MARK: - Life cycle

    init(design: Design?, userCollection: UserCollection = .shared) {
        self.isEditing = design != nil
        self.design = design ?? Design()
        self.userCollection = userCollection
    }

    // MARK: - Public

    func save() {
        if isEditing {
            userCollection.updateDesign(design)
        } else {
            userCollection.addDesign(design)
        }
    }
}
