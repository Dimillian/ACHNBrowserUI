//
//  Collection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 29/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation


extension BidirectionalCollection where Element == Item {
    func filterActive() -> [Item] {
        self.filter({ $0.isActive() })
    }
}

extension Collection where Element: Numeric {
    var total: Element { reduce(0, +) }
}

extension Collection where Element: BinaryInteger {
    var average: Double { isEmpty ? 0 : Double(total) / Double(count) }
}
