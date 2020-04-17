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
    
    func makeWardrobeCell() -> some View {
        NavigationLink(destination: CategoryDetailView(categories: Categories.wardrobe()).navigationBarTitle("Wardrobe")) {
            HStack {
                Image(Categories.dresses.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 46, height: 46)
                Text("Wardrobe")
                    .font(.headline)
                    .foregroundColor(.text)
            }
        }
    }
    
    func makeNatureCell() -> some View {
        NavigationLink(destination: CategoryDetailView(categories: Categories.nature()).navigationBarTitle("Nature")) {
            HStack {
                Image(Categories.fossils.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 46, height: 46)
                Text("Nature")
                    .font(.headline)
                    .foregroundColor(.text)
            }
        }
    }
    
    func makeCategories() -> some View {
        ForEach(categories, id: \.self) { categorie in
            NavigationLink(destination: ItemsListView(viewModel: ItemsViewModel(categorie: categorie))) {
                HStack {
                    Image(categorie.iconName())
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 46, height: 46)
                    Text(categorie.rawValue.capitalized)
                        .font(.headline)
                        .foregroundColor(.text)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                makeNatureCell()
                makeWardrobeCell()
                makeCategories()
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
