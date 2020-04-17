//
//  VillagerRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct VillagerRowView: View {
    @EnvironmentObject private var collection: CollectionViewModel
    
    let villager: Villager
    
    var body: some View {
        HStack {
            Button(action: {
                self.collection.toggleVillager(villager: self.villager)
            }) {
                Image(systemName: self.collection.villagers.contains(self.villager) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }.buttonStyle(BorderlessButtonStyle())
            ItemImage(imageLoader: ImageLoader(path: ACNHApiService.BASE_URL.absoluteString +
                ACNHApiService.Endpoint.villagerIcon(id: villager.id).path()),
                      size: 50)
            Text(villager.name["name-en"] ?? "")
        }
    }
}
