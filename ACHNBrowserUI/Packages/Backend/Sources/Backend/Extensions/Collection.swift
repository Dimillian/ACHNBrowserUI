//
//  Collection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 29/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation


public extension BidirectionalCollection where Element == Item {
    func filterActiveThisMonth(currentDate: Date) -> [Item] {
        self.filter({ $0.isActiveThisMonth(currentDate: currentDate) })
    }
}

public extension Collection where Element: Numeric {
    var total: Element { reduce(0, +) }
}

public extension Collection where Element: BinaryInteger {
    var average: Double { isEmpty ? 0 : Double(total) / Double(count) }
}

extension Collection {
    func count(where test: (Element) throws -> Bool) rethrows -> Int {
        return try self.filter(test).count
    }
}
