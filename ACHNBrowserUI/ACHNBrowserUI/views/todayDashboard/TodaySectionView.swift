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
        case .events:
            return AnyView(TodayEventsSection())
        case .specialCharacters:
            return AnyView(TodaySpecialCharactersSection())
        case .currentlyAvailable:
            return AnyView(TodayCurrentlyAvailableSection(viewModel: viewModel))
        case .collectionProgress:
            return AnyView(TodayCollectionProgressSection(viewModel: viewModel, sheet: $selectedSheet))
        case .birthdays:
            return AnyView(TodayBirthdaysSection())
        case .turnips:
            return AnyView(TodayTurnipSection()
                .onTapGesture {
                    self.uiState.selectedTab = .turnips
            })
        case .subscribe:
            return AnyView(TodaySubscribeSection(sheet: $selectedSheet))
        case .mysteryIsland:
            return AnyView(TodayMysteryIslandsSection())
        case .music:
            return AnyView(TodayMusicPlayerSection())
        case .tasks:
            return AnyView(TodayTasksSection())
        case .nookazon:
            return AnyView(TodayNookazonSection(sheet: $selectedSheet, viewModel: viewModel))
        }
    }
}
