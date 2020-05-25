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
    @EnvironmentObject var uiState: UIState
    
    let section: TodaySection
    
    @ObservedObject var viewModel: DashboardViewModel
    @Binding var selectedSheet: Sheet.SheetType?


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
                return AnyView(TodaySpecialCharactersSection())
            case TodaySection.nameCurrentlyAvailable:
                return AnyView(TodayCurrentlyAvailableSection(viewModel: viewModel))
            case TodaySection.nameCollectionProgress:
                return AnyView(TodayCollectionProgressSection(viewModel: viewModel, sheet: $selectedSheet))
            case TodaySection.nameBirthdays:
                return AnyView(TodayBirthdaysSection())
            case TodaySection.nameTurnips:
                return AnyView(TodayTurnipSection()
                    .onTapGesture {
                        self.uiState.selectedTab = .turnips
                })
            case TodaySection.nameSubscribe:
                return AnyView(TodaySubscribeSection(sheet: $selectedSheet))
            case TodaySection.nameMysteryIsland:
                return AnyView(TodayMysteryIslandsSection())
            case TodaySection.nameMusic:
                return AnyView(TodayMusicPlayerSection())
            case TodaySection.nameTasks:
                return AnyView(TodayTasksSection())
            case TodaySection.nameNookazon:
                return AnyView(TodayNookazonSection(sheet: $selectedSheet, viewModel: viewModel))
            default:
                return AnyView(EmptyView())
        }

    }
}
