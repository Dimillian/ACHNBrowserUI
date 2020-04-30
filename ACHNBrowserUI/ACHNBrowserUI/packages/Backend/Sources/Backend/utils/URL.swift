//
//  URL.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/19/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

extension URL: Identifiable {
    public var id: URL {
        self
    }
}

public extension URL {
    static func nookazon(listing: Listing) -> URL? {
        URL(string: "https://nookazon.com/product/\(listing.itemId)")
    }
}
