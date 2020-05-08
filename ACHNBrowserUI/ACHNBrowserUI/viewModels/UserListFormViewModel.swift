//
//  UserListFormViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

class UserListFormViewModel: ObservableObject {
    @Published var list: UserList
    @Published var selectedIcon: String = "" {
        didSet {
            list.icon = selectedIcon
        }
    }
    
    init(editingList: UserList?) {
        if let list = editingList {
            self.list = list
        } else {
            self.list = UserList()
        }
    }
    
    func save() {
        UserCollection.shared.addList(userList: list)
    }
}
