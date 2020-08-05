//
//  CategoryRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 18/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct CategoryRowView: View {
    @EnvironmentObject private var items: Items
    let category: Backend.Category
    
    var body: some View {
        NavigationLink(destination: LazyView(ItemsView(category: self.category))) {
            HStack {
                Image(category.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 46, height: 46)
                Text(category.label())
                    .style(appStyle: .rowTitle)
                Spacer()
                Text("\(items.categories[category]?.count ?? 0)")
                    .style(appStyle: .rowDescription)
            }
        }.listRowBackground(Color.acSecondaryBackground)
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CategoryRowView(category: .housewares)
        }
    }
}
