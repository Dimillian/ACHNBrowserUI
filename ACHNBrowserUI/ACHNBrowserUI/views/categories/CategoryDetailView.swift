//
//  CategoryDetailView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CategoryDetailView: View {
    let categories: [Category]
    
    var body: some View {
        List {
            ForEach(categories, id: \.rawValue) { category in
                CategoryRowView(category: category)
            }
            
        }
    }
}
