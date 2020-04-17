//
//  VillagerDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct VillagerDetailView: View {
    let villager: Villager
    @ObservedObject var villagersViewModel: VillagersViewModel
    
    private func infoCell(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(.text)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .foregroundColor(.secondaryText)
                .font(.subheadline)
        }
    }
    var body: some View {
        List {
            HStack {
                Spacer()
                ItemImage(imageLoader: ImageLoader(path: ACNHApiService.BASE_URL.absoluteString +
                    ACNHApiService.Endpoint.villagerImage(id: villager.id).path()),
                          size: 150)
                Spacer()
            }
            Section(header: Text("Information")
                .font(.title)
                .fontWeight(.bold)) {
                infoCell(title: "Personality", value: villager.personality)
                infoCell(title: "Birthday", value: villager.birdthday ?? "Unknown")
                infoCell(title: "Species", value: villager.species)
                infoCell(title: "Gender", value: villager.gender)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(villager.name["name-en"] ?? "")
    }
}
