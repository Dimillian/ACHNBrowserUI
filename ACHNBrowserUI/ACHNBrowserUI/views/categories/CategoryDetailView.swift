//
//  CategoryDetailView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CategoryDetailView: View {
    let categories: [Backend.Category]
    
    var body: some View {
        List {
            Section {
                ForEach(categories, id: \.rawValue) { category in
                    CategoryRowView(category: category)
                }
            }
        }.listStyle(GroupedListStyle())
    }
}
