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
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    ItemImage(path: ACNHApiService.BASE_URL.absoluteString +
                        ACNHApiService.Endpoint.villagerImage(id: villager.id).path(),
                              size: 150).cornerRadius(40)
                    Spacer()
                }.padding()
                infoCell(title: "Personality", value: villager.personality).padding()
                infoCell(title: "Birthday", value: villager.formattedBirthday ?? "Unknown").padding()
                infoCell(title: "Species", value: villager.species).padding()
                infoCell(title: "Gender", value: villager.gender).padding()
            }
        }.background(Color.dialogue)
        .navigationBarTitle(villager.name["name-en"] ?? "")
    }
}
