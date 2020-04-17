//
//  CategoriesView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 11/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CategoriesView: View {
    let categories: [Categories]
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List(categories, id: \.self) { categorie in
                NavigationLink(destination: ItemsListView(viewModel: ItemsViewModel(categorie: categorie))) {
                    HStack(spacing: 4) {
                        Image(categorie.iconName())
                            .renderingMode(.original)
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text(categorie.rawValue.capitalized).foregroundColor(.text)
                    }
                }
            }
            .navigationBarTitle(Text("Catalog"), displayMode: .inline)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categories: Categories.items())
    }
}
