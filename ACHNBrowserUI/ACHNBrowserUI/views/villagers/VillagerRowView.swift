//
//  VillagerRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct VillagerRowView: View {

    // MARK: - Type

    enum Style {
        case none
        case species
        case personality
    }
    
    enum Action  {
        case like, home
    }

    // MARK: - Properties

    private let villager: Villager
    private let style: Style
    private let action: Action

    // MARK: - Life cycle

    init(villager: Villager, style: Style = .none, action: Action = .like) {
        self.villager = villager
        self.style = style
        self.action = action
    }
    
    private var actionButton: some View {
        Group {
            if action == .like {
                LikeButtonView(villager: villager)
            } else {
                ResidentButton(villager: villager)
                    .environmentObject(UserCollection.shared)
            }
        }
    }

    var body: some View {
        HStack {
            actionButton
            ItemImage(path: ACNHApiService.BASE_URL.absoluteString +
                ACNHApiService.Endpoint.villagerIcon(id: villager.id).path(),
                      size: 50)

            VStack(alignment: .leading) {
                Text(villager.localizedName)
                    .style(appStyle: .rowTitle)

                if style == .species {
                    Text(LocalizedStringKey(villager.species))
                        .font(.subheadline)
                        .foregroundColor(.acSecondaryText)
                } else if style == .personality {
                    Text(LocalizedStringKey(villager.personality))
                        .font(.subheadline)
                        .foregroundColor(.acSecondaryText)
                }
            }
        }
    }
}

// MARK: - Preview

#if DEBUG
struct VillagerRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            VillagerRowView(villager: static_villager, style: .none)

            VillagerRowView(villager: static_villager, style: .species)

            VillagerRowView(villager: static_villager, style: .personality)
        }
    }
}
#endif
