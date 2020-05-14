//
//  CategoryRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 18/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CategoryRowView: View {
    let category: Backend.Category
    
    var body: some View {
        NavigationLink(destination: ItemsListView(viewModel: ItemsViewModel(category: category))) {
            HStack {
                Image(category.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 46, height: 46)
                Text(category.label())
                    .style(appStyle: .rowTitle)
                Spacer()
                Text("\(Items.shared.categories[category]?.count ?? 0)")
                    .style(appStyle: .rowDescription)
            }
        }
    }
}

struct CategoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CategoryRowView(category: .housewares)
        }
    }
}
