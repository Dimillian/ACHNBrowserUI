//
//  Sequence+Unique.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 14/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

// See tobiasdm answer https://stackoverflow.com/questions/27624331/unique-values-of-array-in-swift
extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return filter { seen.updateValue(true, forKey: $0) == nil }
    }
}
