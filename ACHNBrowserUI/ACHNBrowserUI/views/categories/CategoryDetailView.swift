//
//  CategoryDetailView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CategoryDetailView: View {
    let categories: [Categories]
    
    var body: some View {
        List {
            ForEach(categories, id: \.rawValue) { category in
                NavigationLink(destination: ItemsListView(viewModel: ItemsViewModel(categorie: category))) {
                    HStack {
                        Image(category.iconName())
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 46, height: 46)
                        Text(category.rawValue.localizedCapitalized)
                            .font(.headline)
                            .foregroundColor(.text)
                    }
                }
            }
            
        }
    }
}
