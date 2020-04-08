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
    
    var body: some View {
        NavigationView {
            List(collection.items) { item in
                ItemRowView(item: item)
                    .listRowBackground(Color.dialogue)
            }
            .background(Color.dialogue)
            .navigationBarTitle(Text("Collection"),
                                displayMode: .inline)
        }
    }
}
