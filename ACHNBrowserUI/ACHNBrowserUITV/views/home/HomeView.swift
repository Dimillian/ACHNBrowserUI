//
//  HomeView.swift
//  ACHNBrowserUITV
//
//  Created by Thomas Ricouard on 30/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct HomeView: View {
    @EnvironmentObject private var items: Items
    
    private var categories: [(Backend.Category, [Item])] {
        items.categories
            .map { $0 }
            .sorted(by: \.key.rawValue)
            .reversed()
    }
    
    private func categorySection(category: Backend.Category, items: [Item]) -> some View {
        Section(header: Text(category.label())) {
            HStack {
                ForEach(items.prefix(5)) { item in
                    ItemRow(item: item)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(categories, id: \.0, content: categorySection)
            }.navigationBarTitle(Text("Items home"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
