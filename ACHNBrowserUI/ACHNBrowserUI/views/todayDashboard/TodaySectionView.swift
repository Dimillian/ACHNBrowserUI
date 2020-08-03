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

    @ViewBuilder
    var body: some View {
        if section.enabled {
            Section(header: SectionHeaderView(text: section.sectionName,
                                              icon: section.iconName)) {
                makeView()
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    func makeView() -> some View {
        switch(section.name) {
        case .events:
            TodayEventsSection()
        case .specialCharacters:
            TodaySpecialCharactersSection()
        case .currentlyAvailable:
            TodayCurrentlyAvailableSection()
        case .collectionProgress:
            TodayCollectionProgressSection(viewModel: viewModel, sheet: $selectedSheet)
        case .birthdays:
            TodayBirthdaysSection()
        case .turnips:
            TodayTurnipSection()
                .onTapGesture {
                    self.uiState.selectedTab = .turnips
                }
        case .subscribe:
            TodaySubscribeSection(sheet: $selectedSheet)
        case .mysteryIsland:
            TodayMysteryIslandsSection()
        case .music:
            TodayMusicPlayerSection()
        case .tasks:
            TodayTasksSection(sheet: $selectedSheet)
        case .chores:
            TodayChoresSection()
        case .villagerVisits:
            TodayVillagerVisitsSection(sheet: $selectedSheet)
        case .dodoCode:
            TodayDodoCodeSection()
        case .news:
            TodayNewsSection()
        case .dreamCode:
            TodayDreamCodeSection()
        }
    }
}
