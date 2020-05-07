//
//  VillagerDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct VillagerDetailView: View {
    let villager: Villager
    
    @State private var backgroundColor = Color.dialogue
    @State private var textColor = Color.text
    @State private var secondaryTextColor = Color.secondaryText
    
    private func infoCell(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(textColor)
                .font(.headline)
                .fontWeight(.bold)
            Spacer()
            Text(value)
                .foregroundColor(secondaryTextColor)
                .font(.subheadline)
        }.listRowBackground(Rectangle().fill(backgroundColor))
    }
    var body: some View {
        List {
            HStack {
                Spacer()
                ItemImage(path: ACNHApiService.BASE_URL.absoluteString +
                    ACNHApiService.Endpoint.villagerImage(id: villager.id).path(),
                          size: 150).cornerRadius(40)
                Spacer()
            }
            .listRowBackground(Rectangle().fill(backgroundColor))
            .padding()
            infoCell(title: "Personality", value: villager.personality).padding()
            infoCell(title: "Birthday", value: villager.formattedBirthday ?? "Unknown").padding()
            infoCell(title: "Species", value: villager.species).padding()
            infoCell(title: "Gender", value: villager.gender).padding()
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarItems(trailing: LikeButtonView(villager: villager).safeHoverEffectBarItem(position: .trailing))
        .navigationBarTitle(Text(villager.name["name-en"] ?? ""), displayMode: .automatic)
        .onAppear {
            let url = ACNHApiService.BASE_URL.absoluteString +
                ACNHApiService.Endpoint.villagerIcon(id: self.villager.id).path()
            ImageService.getImageColors(key: url) { colors in
                if let colors = colors {
                    withAnimation(.easeInOut) {
                        self.backgroundColor = Color(colors.background)
                        self.textColor = Color(colors.primary)
                        self.secondaryTextColor = Color(colors.detail)
                    }
                }
            }
        }
    }
}
