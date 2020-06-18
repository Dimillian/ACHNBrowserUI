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
        Group {
            if section.enabled {
                Section(header: SectionHeaderView(text: section.sectionName,
                                                  icon: section.iconName)) {
                                                    makeView()
                }
            } else {
                EmptyView()
            }
        }
    }

    func makeView() -> some View {
        switch(section.name) {
        case .events:
            return AnyView(TodayEventsSection())
        case .specialCharacters:
            return AnyView(TodaySpecialCharactersSection())
        case .currentlyAvailable:
            return AnyView(TodayCurrentlyAvailableSection())
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
            return AnyView(TodayTasksSection(sheet: $selectedSheet))
        case .chores:
            return AnyView(TodayChoresSection())
        case .nookazon:
            return AnyView(TodayNookazonSection(sheet: $selectedSheet, viewModel: viewModel))
        case .villagerVisits:
            return AnyView(TodayVillagerVisitsSection(sheet: $selectedSheet))
        case .dodoCode:
            return AnyView(TodayDodoCodeSection())
        }
    }
}
