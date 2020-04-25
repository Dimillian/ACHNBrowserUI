//
//  CategoryRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 18/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CategoryRowView: View {
    let category: Category
    
    var body: some View {
        NavigationLink(destination: ItemsListView(viewModel: ItemsViewModel(category: category))) {
            HStack {
                Image(category.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 46, height: 46)
                Text(category.label())
                    .font(.headline)
                    .foregroundColor(.text)
            }
        }
    }
}
