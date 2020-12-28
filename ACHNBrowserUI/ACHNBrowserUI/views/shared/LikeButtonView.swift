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
    @StateObject private var viewModel: LikeButtonViewModel
    @Binding private var likedItemWithVariants: Item?
    
    init(
        item: Item,
        variant: Variant?,
        likedItemWithVariants: Binding<Item?> = .constant(nil)
    ) {
        _viewModel = StateObject(wrappedValue: LikeButtonViewModel(item: item, variant: variant))
        _likedItemWithVariants = likedItemWithVariants
    }
    
    init(villager: Villager) {
        _viewModel = StateObject(wrappedValue: LikeButtonViewModel(villager: villager))
        _likedItemWithVariants = .constant(nil)
    }
        
    var imageName: String {
        if viewModel.item != nil {
            if viewModel.item?.isCritter == true {
                return viewModel.isInCollection ? "checkmark.seal.fill" : "checkmark.seal"
            } else {
                if viewModel.hasSomeVariations {
                    switch viewModel.variantsCompletionStatus {
                    case .unstarted: return "star"
                    case .partial: return "star.leadinghalf.fill"
                    case .complete: return "star.fill"
                    }
                }
                return viewModel.isInCollection ? "star.fill" : "star"
            }
        } else {
            return viewModel.isInCollection ? "heart.fill" : "heart"
        }
    }
    
    var color: Color {
        if viewModel.item != nil {
            if viewModel.item?.isCritter == true {
                return .acTabBarBackground
            }
            return .yellow
        }
        return .red
    }
    
    var body: some View {
        Button(action: {
            if viewModel.hasSomeVariations {
                likedItemWithVariants = viewModel.item
            } else {
                let added = self.viewModel.toggleCollection()
                FeedbackGenerator.shared.triggerNotification(type: added ? .success : .warning)
            }
        }) {
            Image(systemName: imageName).foregroundColor(color)
        }
        .scaleEffect(viewModel.isInCollection ? 1.3 : 1.0)
        .buttonStyle(BorderlessButtonStyle())
        .animation(.spring(response: 0.5, dampingFraction: 0.3, blendDuration: 0.5))
    }
}

struct StarButtonView_Previews: PreviewProvider {
    static var previews: some View {
        LikeButtonView(item: static_item, variant: nil)
    }
}
