//
//  TodayVillagerVisitsSection.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 06/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend
import UI

struct TodayVillagerVisitsSection: View {
    @EnvironmentObject private var collection: UserCollection
    @EnvironmentObject private var subManager: SubscriptionManager
    @Binding var sheet: Sheet.SheetType?

    private var residents: [Villager] { collection.residents }
    private var visitedResidents: [Villager] { collection.visitedResidents }
    private var rows: Int { Int((Double(residents.count)/4).rounded(.up)) }

    var body: some View {
        Group {
            if residents.count > 0 {
                villagerVisits
            } else {
                Text("Who have you talked to today? Find the villagers you have visited and tap the home icon on the villager’s page to keep track.")
                    .foregroundColor(.acText)
                    .padding(.vertical, 8)
            }
        }
    }

    private var villagerVisits: some View {
        VStack(spacing: 15) {
            bubbles
            Text("Long press on a villager to see more info about them")
                .foregroundColor(.acText)
            Text("Reset")
                .onTapGesture(perform: reset)
                .foregroundColor(.acText)
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(Color.acText.opacity(0.2))
                .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var bubbles: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 50)), count: 4),
                  alignment: .center,
                  spacing: 16) {
            ForEach(residents) { villager in
                bubble(villager: villager)
            }
        }
    }

    private func bubble(villager: Villager) -> some View {
        ZStack {
            Circle().foregroundColor(Color.acBackground)
            icon(for: villager)
                .aspectRatio(contentMode: .fit)
                .overlay(checkCircle(for: villager), alignment: .topTrailing)
        }
        .frame(maxHeight: 44)
        .onTapGesture {
            self.collection.toggleVisitedResident(villager: villager)
            FeedbackGenerator.shared.triggerSelection()
        }
        .onLongPressGesture {
            self.sheet = .villager(
                villager: villager,
                subManager: self.subManager,
                collection: self.collection
            )
        }
    }

    private func icon(for villager: Villager) -> ItemImage {
        ItemImage(
            path: ACNHApiService.BASE_URL.absoluteString + ACNHApiService.Endpoint.villagerIcon(id: villager.id).path(),
            size: 50
        )
    }

    private func checkCircle(for villager: Villager) -> some View {
        ZStack {
            Circle()
                .scale(2)
                .fixedSize()
                .foregroundColor(Color.acBackground)
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .opacity(visitedResidents.contains(villager) ? 1 : 0)
                .animation(.linear)
        }
    }

    private func reset() {
        collection.resetVisitedResidents()
    }
}


struct TodayVillagerVisitsSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TodayVillagerVisitsSection(sheet: .constant(nil))
        }.environmentObject(mockedUserCollection)
    }

    static var mockedUserCollection: UserCollection {
        let userCollection = UserCollection(iCloudDisabled: true)
        userCollection.residents = mockedResidents
        return userCollection
    }

    static var mockedResidents: [Villager] {
        """
[
    { "id": 357, "name": { "name-en": "Blaire" }, "personality": "", "gender": "", "species": "" },
    { "id": 334, "name": { "name-en": "Bonbon" }, "personality": "", "gender": "", "species": "" },
    { "id": 281, "name": { "name-en": "Amelia" }, "personality": "", "gender": "", "species": "" },
    { "id": 171, "name": { "name-en": "Diva" }, "personality": "", "gender": "", "species": "" },
    { "id": 262, "name": { "name-en": "Moose" }, "personality": "", "gender": "", "species": "" },
    { "id": 102, "name": { "name-en": "Bam" }, "personality": "", "gender": "", "species": "" },
    { "id": 278, "name": { "name-en": "Flora" }, "personality": "", "gender": "", "species": "" },
    { "id": 73, "name": { "name-en": "Olive" }, "personality": "", "gender": "", "species": "" },
    { "id": 29, "name": { "name-en": "Admiral" }, "personality": "", "gender": "", "species": "" },
    { "id": 324, "name": { "name-en": "Tiffany" }, "personality": "", "gender": "", "species": "" }
]
"""
            .data(using: .utf8)
            .map({ try! JSONDecoder().decode([Villager].self, from: $0) }) ?? []
    }
}
