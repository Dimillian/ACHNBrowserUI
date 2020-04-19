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
    
    @State private var isPreferencesShown = false
    
    private var preferenceButton: some View {
        Button(action: {
            self.isPreferencesShown = true
        }, label: {
            Image(systemName: "wrench").imageScale(.medium)
        })
    }

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
    
    var body: some View {
        NavigationView {
            List {
                makeNatureCell()
                makeWardrobeCell()
                makeCategories()
            }
            .navigationBarTitle(Text("Catalog"), displayMode: .inline)
            .navigationBarItems(trailing: preferenceButton)
            .sheet(isPresented: $isPreferencesShown, content: { SettingsView() })
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categories: Categories.items())
    }
}
