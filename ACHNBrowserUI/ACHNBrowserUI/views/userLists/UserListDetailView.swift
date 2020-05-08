//
//  UserListDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct UserListDetailView: View {
    let list: UserList
    
    var body: some View {
        List {
            ForEach(list.items) { item in
                NavigationLink(destination: ItemDetailView(item: item)) {
                    ItemRowView(displayMode: .large, item: item)
                }
            }
        }.navigationBarTitle(Text(list.name))
    }
}
