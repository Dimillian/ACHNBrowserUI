//
//  CategoryHeaderView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CategoryHeaderView: View {
    let category: Backend.Category
    
    var body: some View {
        HStack {
            Image(category.iconName())
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 30)
            Text(category.label())
                .font(.subheadline)
        }
    }
}

struct CategoryHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHeaderView(category: .housewares)
    }
}
