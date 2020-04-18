//
//  CategoriesRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 18/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CategoryRowView: View {
    let category: Categories
    
    var body: some View {
        NavigationLink(destination: ItemsListView(viewModel: ItemsViewModel(categorie: category))) {
            HStack {
                Image(category.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 46, height: 46)
                Text(category.rawValue.capitalized)
                    .font(.headline)
                    .foregroundColor(.text)
            }
        }
    }
}
