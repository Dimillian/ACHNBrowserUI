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

    // MARK: - Properties

    @EnvironmentObject private var collection: UserCollection
    private let villager: Villager
    private let style: Style

    // MARK: - Life cycle

    init(villager: Villager, style: Style = .none) {
        self.villager = villager
        self.style = style
    }

    var body: some View {
        HStack {
            LikeButtonView(villager: villager)
            ItemImage(path: ACNHApiService.BASE_URL.absoluteString +
                ACNHApiService.Endpoint.villagerIcon(id: villager.id).path(),
                      size: 50)

            VStack(alignment: .leading) {
                Text(villager.localizedName)
                    .style(appStyle: .rowTitle)

                if style == .species {
                    Text(villager.species)
                        .font(.subheadline)
                        .foregroundColor(.acSecondaryText)
                } else if style == .personality {
                    Text(villager.personality)
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
