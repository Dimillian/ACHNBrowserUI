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
        }
        .background(backgroundColor)
        .navigationBarItems(trailing: LikeButtonView(villager: villager))
        .navigationBarTitle(villager.name["name-en"] ?? "")
        .onAppear {
            let url = ACNHApiService.BASE_URL.absoluteString +
                ACNHApiService.Endpoint.villagerIcon(id: self.villager.id).path()
            ImageService.shared.getImageColors(key: url) { colors in
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
