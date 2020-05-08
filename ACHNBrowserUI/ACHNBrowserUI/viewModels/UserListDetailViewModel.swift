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
    @Published var selectedItems: [Item] = []
    
    init(list: UserList) {
        self.list = list
    }
    
    func saveItems() {
        UserCollection.shared.addItems(for: list.id, items: selectedItems)
        self.selectedItems = []
    }
    
    func deleteItem(at: Int) {
        UserCollection.shared.deleteItem(for: list.id, at: at)
    }
}
