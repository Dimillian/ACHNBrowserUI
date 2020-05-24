//
//  TodaySectionView.swift
//  ACHNBrowserUI
//
//  Created by theunimpossible on 5/24/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TodaySectionView: View {
    let section: TodaySection
    let viewModel: DashboardViewModel
    @Binding var selectedSheet: Sheet.SheetType?
    let villagers: [Villager]
    let turnipPredictionsService: TurnipPredictionsService
    let uiState: UIState


    var body: some View {
        makeView()
    }

    func makeView() -> some View {
       if !section.enabled {
            return AnyView(EmptyView())
        }

        switch(section.name) {
            case TodaySection.nameEvents:
                return AnyView(TodayEventsSection())
            case TodaySection.nameSpecialCharacters:
                return AnyView(TodaySpecialCharacters())
            case TodaySection.nameCurrentlyAvailable:
                return AnyView(TodayCurrentlyAvailableSection(viewModel: viewModel))
            case TodaySection.nameCollectionProgress:
                return AnyView(TodayCollectionProgressSection(viewModel: viewModel, sheet: $selectedSheet))
            case TodaySection.nameBirthdays:
                return AnyView(TodayBirthdaysSection(villagers: villagers))
            case TodaySection.nameTurnips:
                return AnyView(TodayTurnipSection(predictions: turnipPredictionsService.predictions)
                    .onTapGesture {
                        self.uiState.selectedTab = .turnips
                })
            case TodaySection.nameSubscribe:
                return AnyView(TodaySubscribeSection(sheet: $selectedSheet))
            case TodaySection.nameMysteryIsland:
                return AnyView(TodayMysteryIslandsSection())
            default:
                return AnyView(EmptyView())
        }

    }
}
