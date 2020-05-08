//
//  DashboardView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/18/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import UIKit
import Backend
import UI

struct DashboardView: View {
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject private var userDefaults = AppUserDefaults.shared
    @ObservedObject private var viewModel = DashboardViewModel()
    @ObservedObject private var villagersViewModel = VillagersViewModel()
    @ObservedObject private var turnipsPredictionsService = TurnipsPredictionService.shared
    
    @State var selectedSheet: Sheet.SheetType?
    
    private var preferenceButton: some View {
        Button(action: {
            self.selectedSheet = .settings(subManager: SubcriptionManager.shared)
        }, label: {
            Image(systemName: "slider.horizontal.3").imageScale(.medium)
        })
        .safeHoverEffectBarItem(position: .trailing)
    }
    
    private var aboutButton: some View {
        Button(action: {
            self.selectedSheet = .about
        }, label: {
            Image(systemName: "info.circle").imageScale(.large)
        })
        .padding(10)
        .safeHoverEffect()
        .offset(x:-10)
    }
        
    private var todayText: String {
        "Today\(!userDefaults.islandName.isEmpty ? " on \(userDefaults.islandName)" : "")"
    }
    
    private func makeDateView() -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM"
        let dateString = formatter.string(from: Date())
        return Section(header: SectionHeaderView(text: todayText)) {
            VStack(alignment: .leading) {
                Text(dateString).style(appStyle: .title)
                DashboardEventTextView().padding(.top, 4)
            }
            .padding(.vertical, 5)
        }
    }
    
    private func makeBirthdayView() -> some View {
        Section(header: SectionHeaderView(text: "Villager birthday")) {
            ForEach(villagersViewModel.todayBirthdays) { villager in
                NavigationLink(destination: VillagerDetailView(villager: villager),
                               label: {
                                VillagerRowView(villager: villager)
                })
            }
        }
    }
    
    private func makeTurnipsPredictionsView() -> some View {
        Section(header: SectionHeaderView(text: "Turnip predictions")) {
            Group {
                if turnipsPredictionsService.predictions?.todayAverages?.isEmpty == true {
                    Text("Today is sunday, don't forget to buy more turnips and fill your buy price")
                } else {
                    Text("Today average buy prices should be ") +
                        Text("\(turnipsPredictionsService.predictions!.todayAverages![0])")
                            .foregroundColor(.bell)
                            .fontWeight(.semibold) +
                        Text(" for this morning and ") +
                        Text("\(turnipsPredictionsService.predictions!.todayAverages![1])")
                            .foregroundColor(.bell)
                            .fontWeight(.semibold) +
                        Text(" for this afternoon")
                }
            }
            .foregroundColor(.text)
            .onTapGesture {
                self.uiState.selectedTab = .turnips
            }
        }
    }
    
    private func makeTopTurnipSection() -> some View {
        Section(header: SectionHeaderView(text: "Top Turnip Island")) {
            if viewModel.island == nil {
                Text("Loading...")
                    .foregroundColor(.secondary)
            }
            viewModel.island.map {
                TurnipIslandRow(island: $0)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                makeDateView()
                DashboardAvailableCrittersSection(viewModel: viewModel)
                DashboardCollectionProgressSection(viewModel: viewModel)
                if !villagersViewModel.todayBirthdays.isEmpty {
                    makeBirthdayView()
                }
                if turnipsPredictionsService.predictions?.todayAverages != nil {
                    makeTurnipsPredictionsView()
                }
                if viewModel.island != nil {
                    makeTopTurnipSection()
                }
                DashboardNookazonListingSection(selectedSheet: $selectedSheet,
                                                viewModel: viewModel)
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .navigationBarTitle("Dashboard")
            .navigationBarItems(leading: aboutButton,
                                trailing: preferenceButton)
            ActiveCrittersView(activeFishes: viewModel.fishes.filterActive(),
                               activeBugs: viewModel.bugs.filterActive())
        }
        .sheet(item: $selectedSheet, content: {
            Sheet(sheetType: $0)
        })
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
