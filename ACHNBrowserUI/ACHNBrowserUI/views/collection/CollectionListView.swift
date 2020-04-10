//
//  CollectionListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct CollectionListView: View {
    @EnvironmentObject private var collection: Collection
    @State private var selectedCatory: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: self.$selectedCatory, label: Text("")) {
                    Text("All").tag(0)
                    ForEach(self.collection.categories, id: \.self) { category in
                        Text(category).tag(self.collection.categories.firstIndex(of: category)! - 1)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                List(collection.items) { item in
                    NavigationLink(destination: ItemDetailView(item: item,
                                                               viewModel: ItemsViewModel(categorie: item.appCategory ?? .housewares))) {
                                                                ItemRowView(item: item)
                                                                    .listRowBackground(Color.dialogue)
                    }
                }
            }
            .background(Color.dialogue)
            .navigationBarTitle(Text("Collection"),
                                displayMode: .inline)
        }
    }
}
