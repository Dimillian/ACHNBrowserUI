//
//  Date.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/19/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

extension Date {
    func isSunday() -> Bool {
        Calendar(identifier: .gregorian).dateComponents([.weekday], from: self).weekday == 1
    }
}

