//
//  EditMode.swift
//  ACHNBrowserUI
//
//  Created by Jan on 31.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

extension EditMode {
    mutating func toggle() {
        switch self {
        case .active: self = .inactive
        case .inactive: self = .active
        case .transient: break;
        @unknown default: break;
        }
    }
}
