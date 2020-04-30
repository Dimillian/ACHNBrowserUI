//
//  Array.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 29/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

public extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


public extension Array where Element == Item {
    mutating func toggle(item: Item) -> Bool {
        var added = false
        if contains(item) {
            removeAll(where: { $0 == item })
        } else {
            added = true
            append(item)
        }
        return added
    }
}
