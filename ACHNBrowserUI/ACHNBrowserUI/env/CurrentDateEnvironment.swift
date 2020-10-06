//
//  CurrentDateEnvironment.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 05/10/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CurrentDateKey: EnvironmentKey {
    static let defaultValue = Date()
}

extension EnvironmentValues {
    var currentDate: Date {
        get { self[CurrentDateKey.self] }
        set { self[CurrentDateKey.self] = newValue }
    }
}
