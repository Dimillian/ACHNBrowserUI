//
//  Collection+SafeDirectAccess.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 31/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe i: Index) -> Iterator.Element? {
        indices.contains(i) ? self[i] : nil
    }
}
