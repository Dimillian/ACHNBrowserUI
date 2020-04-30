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
    }
    
    private func categorySection(category: Backend.Category, items: [Item]) -> some View {
        Section(header: Text(category.label())) {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack {
                    ForEach(items) { item in
                        Text(item.name)
                    }
                }
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(categories, id: \.0, content: categorySection)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
