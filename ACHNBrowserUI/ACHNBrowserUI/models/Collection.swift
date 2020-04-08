//
//  Collection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

class Collection: ObservableObject {
    @Published var items: [Item] = []
}
