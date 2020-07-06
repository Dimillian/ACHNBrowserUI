//
//  CollectionDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 13/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct CollectionProgressDetailView: View {
    @EnvironmentObject private var items: Items
        
    var body: some View {
        List {
            ForEach(Category.collectionCategories(), id: \.self) { category in
                NavigationLink(destination: LazyView(ItemsView(category: category))) {
                    CollectionProgressRow(category: category, barHeight: 20)
                }
                .listRowBackground(Color.acSecondaryBackground)
            }
        }
        .navigationBarTitle(Text("Collection Progress"),
                            displayMode: .automatic)
    }
}

struct CollectionProgressDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionProgressDetailView()
                .environmentObject(Items.shared)
                .environmentObject(UserCollection.shared)
        }
    }
}
