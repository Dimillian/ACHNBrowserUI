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
            switch self.item.appCategory {
            case .bugsSouth, .bugsNorth, .fishesSouth, .fishesNorth, .fossils:
                let added = self.collection.toggleCritters(critter: self.item)
                FeedbackGenerator.shared.triggerNotification(type: added ? .success : .warning)
            default:
                let added = self.collection.toggleItem(item: self.item)
                FeedbackGenerator.shared.triggerNotification(type: added ? .success : .warning)
            }
        }) {
            Image(systemName: self.isInCollection ? "star.fill" : "star")
                .foregroundColor(.yellow)
        }
        .scaleEffect(self.isInCollection ? 1.2 : 1.0)
        .buttonStyle(BorderlessButtonStyle())
        .animation(.interactiveSpring())
    }
}

struct StarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        StarButtonView(item: static_item)
    }
}
