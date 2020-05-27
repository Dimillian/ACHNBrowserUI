//
//  MoreViewModel.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 27.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Backend

struct CollectionMoreDetailViewModel {

    // MARK: - Types

    enum Row: String, CaseIterable, CustomStringConvertible {
        case critters
        case designs

        var description: String {
            switch self {
            case .critters: return "Critters"
            case .designs: return "Creators and Designs"
            }
        }
    }

    // MARK: - Properties

    let rows = Row.allCases
}
