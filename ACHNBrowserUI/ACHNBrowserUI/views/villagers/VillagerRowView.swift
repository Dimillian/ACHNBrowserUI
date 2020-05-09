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
    @EnvironmentObject private var collection: UserCollection
    
    let villager: Villager
    
    var body: some View {
        HStack {
            LikeButtonView(villager: villager).environmentObject(collection)
            ItemImage(path: ACNHApiService.BASE_URL.absoluteString +
                ACNHApiService.Endpoint.villagerIcon(id: villager.id).path(),
                      size: 50)
            Text(villager.name["name-en"] ?? "")
                .style(appStyle: .rowTitle)
        }
    }
}
