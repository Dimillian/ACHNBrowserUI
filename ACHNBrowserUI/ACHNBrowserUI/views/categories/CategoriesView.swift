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
    
    @ObservedObject var viewModel = CategoriesSearchViewModel()
    
    func makeCategories() -> some View {
        ForEach(categories, id: \.self) { categorie in
            CategoryRowView(category: categorie)
        }
    }
    
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
    
    func makeSearchCategoryHeader(category: Categories) -> some View {
        HStack {
            Image(category.iconName())
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 30)
            Text(category.label())
                .font(.subheadline)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $viewModel.searchText)
                    .listRowBackground(Color.grass)
                    .foregroundColor(.white)
                if viewModel.searchText.isEmpty {
                    makeNatureCell()
                    makeWardrobeCell()
                    makeCategories()
                } else {
                    ForEach(viewModel.searchResults.keys.map{ $0 }, id: \.self) { key in
                        Section(header: self.makeSearchCategoryHeader(category: key)) {
                            ForEach(self.viewModel.searchResults[key] ?? []) { item in
                                ItemRowView(item: item)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Catalog"), displayMode: .inline)
        }
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categories: Categories.items())
    }
}
