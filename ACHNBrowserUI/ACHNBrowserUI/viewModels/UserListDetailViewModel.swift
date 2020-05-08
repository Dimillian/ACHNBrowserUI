//
//  UserListViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import Backend

class UserListDetailViewModel: ObservableObject {
    @Published var list: UserList
    @Published var selectedItems = Set<String>()
    
    init(list: UserList) {
        self.list = list
    }
    
    func saveItems() {
        let items = Items.shared.categories
            .mapValues({ $0.filter({
                selectedItems.contains($0.name)
            }) })
            .filter { !$0.value.isEmpty }
            .mapValues { Array($0) }
            .flatMap{ $1 }
        self.list = UserCollection.shared.addItems(for: list.id, items: items)
        self.selectedItems = Set<String>()
    }
    
    func deleteItem(at: Int) {
        self.list = UserCollection.shared.deleteItem(for: list.id, at: at)
    }
}
