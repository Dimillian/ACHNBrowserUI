//
//  LikeButtonView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/19/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct LikeButtonView: View {
    let item: Item?
    let variant: Variant?
    let villager: Villager?
    @EnvironmentObject private var collection: UserCollection
    
    init(item: Item, variant: Variant?) {
        self.item = item
        self.variant = variant
        self.villager = nil
    }
    
    init(villager: Villager) {
        self.villager = villager
        self.variant = nil
        self.item = nil
    }
    
    private var isInCollection: Bool {
        if let item = item {
            if let variant = variant {
                return collection.containVariant(item: item, variant: variant)
            }
            return collection.items.contains(item) || collection.critters.contains(item)
        } else if let villager = villager {
            return collection.villagers.contains(villager)
        }
        return false
    }
    
    var imageName: String {
        if item != nil {
            if item?.isCritter == true {
                return isInCollection ? "checkmark.seal.fill" : "checkmark.seal"
            } else {
                return isInCollection ? "star.fill" : "star"
            }
        } else {
            return isInCollection ? "heart.fill" : "heart"
        }
    }
    
    var color: Color {
        if item != nil {
            if item?.isCritter == true {
                return .acTabBarBackground
            }
            return .yellow
        }
        return .red
    }
    
    var body: some View {
        Button(action: {
            if let item = self.item {
                switch item.appCategory {
                case .fish, .bugs, .fossils:
                    let added = self.collection.toggleCritters(critter: item)
                    FeedbackGenerator.shared.triggerNotification(type: added ? .success : .warning)
                default:
                    if let variant = self.variant {
                        let added = self.collection.toggleVariant(item: item, variant: variant)
                        FeedbackGenerator.shared.triggerNotification(type: added ? .success : .warning)
                        return
                    }
                    let added = self.collection.toggleItem(item: item)
                    FeedbackGenerator.shared.triggerNotification(type: added ? .success : .warning)
                }
            } else if let villager = self.villager {
                let added =  self.collection.toggleVillager(villager: villager)
                FeedbackGenerator.shared.triggerNotification(type: added ? .success : .warning)
            }
        }) {
            Image(systemName: imageName).foregroundColor(color)
        }
        .scaleEffect(self.isInCollection ? 1.3 : 1.0)
        .buttonStyle(BorderlessButtonStyle())
        .animation(.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.5))
    }
}

struct StarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LikeButtonView(item: static_item, variant: nil)
            .environmentObject(UserCollection.shared)
    }
}
