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

    // MARK: - Life cycle

    init(design: Design?) {
        if let design = design {
            self.design = design
        } else {
            self.design = Design()
        }
    }

    // MARK: - Public

    func save() {
        UserCollection.shared.addDesign(design)
    }
}
