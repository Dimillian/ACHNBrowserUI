//
//  TodayVillagerVisitsSection.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 06/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct TodayVillagerVisitsSection: View {
    @EnvironmentObject private var collection: UserCollection
    @Binding var sheet: Sheet.SheetType?

    private var residents: [Villager] { collection.residents }

    var body: some View {
        Section(header: SectionHeaderView(text: "Villager Visits", icon: "person.crop.circle.fill.badge.checkmark")) {
            VStack(spacing: 15) {
                GridStack<AnyView>(rows: Int((Double(residents.count)/4).rounded(.up)), columns: 4, showDivider: false) { (row, column) in
                    let villagerIndex = row * 4 + column
                    guard let villager = self.residents[safe: villagerIndex] else {
                        return EmptyView().eraseToAnyView()
                    }
                    return self.bubble(villager: villager, index: villagerIndex).eraseToAnyView()
                }
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
    }

    private func bubble(villager: Villager, index: Int) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color("ACBackground"))
            icon(for: villager)
                .scaleEffect(0.8)
                .aspectRatio(contentMode: .fit)
            ZStack {
                Circle()
                    .stroke(lineWidth: 4.0)
                    .opacity(0.3)
                    .foregroundColor(Color.red)
                Circle()
                    .trim(from: 0.0, to: collection.visitedResidents.contains(villager) ? 1.0 : 0.0)
                    .stroke(style: StrokeStyle(lineWidth: 4.0, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.green)
                    .rotationEffect(Angle(degrees: 270.0))
                    .animation(.easeInOut)
            }
        }
        .frame(maxHeight: 44)
        .onTapGesture {
            self.collection.toggleVisitedResident(villager: villager)
            FeedbackGenerator.shared.triggerSelection()
        }
        .onLongPressGesture {
            // TODO: open a detail for the villager in a modal
        }
    }

    private func icon(for villager: Villager) -> ItemImage {
        ItemImage(
            path: ACNHApiService.BASE_URL.absoluteString + ACNHApiService.Endpoint.villagerIcon(id: villager.id).path(),
            size: 50
        )
    }

    private func reset() {
        collection.resetVisitedResidents()
    }
}

