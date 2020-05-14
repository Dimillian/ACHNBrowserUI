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
            Text(villager.localizedName)
                .style(appStyle: .rowTitle)
        }
    }
}

struct VillagerRowView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            VillagerRowView(villager: static_villager)
                .environmentObject(UserCollection.shared)
        }
    }
}
