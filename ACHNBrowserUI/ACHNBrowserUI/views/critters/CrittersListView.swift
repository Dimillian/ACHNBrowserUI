//
//  CrittersListView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 27.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CrittersListView: View {

    // MARK: - Properties

    @EnvironmentObject private var collection: UserCollection

    // MARK: - Public

    var body: some View {
        List {
            if !collection.critters.isEmpty {
                ForEach(collection.critters) { critter in
                    NavigationLink(destination: ItemDetailView(item: critter)) {
                        ItemRowView(displayMode: .large, item: critter)
                    }
                }
            } else {
                MessageView(collectionName: "critters")
            }
        }
        .navigationBarTitle(Text("Critters"), displayMode: .automatic)
    }
}

// MARK: - Preview

#if DEBUG
struct CrittersListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CrittersListView()
        }
        .environmentObject(UserCollection.shared)
    }
}
#endif
