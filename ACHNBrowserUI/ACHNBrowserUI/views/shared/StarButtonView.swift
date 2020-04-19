//
//  StarButtonView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/19/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct StarButtonView: View {
    let item: Item
    @EnvironmentObject private var collection: UserCollection
    
    private var isInCollection: Bool {
        collection.items.contains(item) || collection.critters.contains(item)
    }
    
    var body: some View {
        Button(action: {
            if let category = self.item.appCategory {
                switch category {
                case .bugsSouth, .bugsNorth, .fishesSouth, .fishesNorth, .fossils:
                    self.collection.toggleCritters(critter: self.item)
                default:
                    self.collection.toggleItem(item: self.item)
                }
            } else {
                self.collection.toggleItem(item: self.item)
            }
        }) {
            Image(systemName: self.isInCollection ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}

struct StarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StarButtonView(item: static_item)
    }
}
