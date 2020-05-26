//
//  CollectionDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 13/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CollectionProgressDetailView: View {
    @EnvironmentObject private var items: Items
    @EnvironmentObject private var collection: UserCollection
    
    var body: some View {
        List {
            ForEach(Category.collectionCategories(), id: \.self) { category in
                NavigationLink(destination: ItemsListView(viewModel: ItemsViewModel(category: category))) {
                    CollectionProgressRow(category: category, barHeight: 20)
                }
            }
        }
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle(Text("Collection Progress"),
                            displayMode: .automatic)
    }
}

struct CollectionProgressDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CollectionProgressDetailView()
    }
}
