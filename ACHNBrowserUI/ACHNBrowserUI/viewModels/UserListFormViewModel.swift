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
    @Published var selectedIcon: String? {
        didSet {
            list.icon = selectedIcon
        }
    }
    
    private var editing: Bool
    
    init(editingList: UserList?) {
        self.editing = editingList != nil
        if let list = editingList {
            self.list = list
        } else {
            self.list = UserList()
        }
    }
    
    func save() {
        if editing {
            UserCollection.shared.editList(userList: list)
        } else {
            UserCollection.shared.addList(userList: list)
        }
    }
}
