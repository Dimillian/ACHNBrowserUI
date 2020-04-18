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
    
    var body: some View {
        NavigationView {
            List {
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
