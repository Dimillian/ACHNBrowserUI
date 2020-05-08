//
//  UserListRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct UserListRow: View {
    let list: UserList
    
    var body: some View {
        HStack {
            if list.icon != nil {
                Image(list.icon!).resizable().frame(width: 30, height: 30)
            }
            VStack(alignment: .leading) {
                Text(list.name).style(appStyle: .rowTitle).lineLimit(1)
                if (!list.description.isEmpty) {
                    Text(list.description).style(appStyle: .rowDescription).lineLimit(1)
                }
            }
        }
    }
}
