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

struct DashboardView: View {
    enum Sheet: Identifiable {
        case safari(URL), settings, about
        
        var id: String {
            switch self {
            case .safari(let url):
                return url.absoluteString
            case .settings:
                return "settings"
            case .about:
                return "about"
            }
        }
    }
    
    @EnvironmentObject private var uiState: UIState
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject private var viewModel = DashboardViewModel()
    @ObservedObject private var villagersViewModel = VillagersViewModel()
    @State var selectedSheet: Sheet?
    
    private var preferenceButton: some View {
        Button(action: {
            self.selectedSheet = .settings
        }, label: {
            Image(systemName: "slider.horizontal.3").imageScale(.medium)
        })
    }
    
    private var aboutButton: some View {
        Button(action: {
            self.selectedSheet = .about
        }, label: {
            Image(systemName: "info.circle").imageScale(.large)
        })
    }
    
    private func makeSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .settings:
            return AnyView(SettingsView().environmentObject(SubcriptionManager.shared))
        case .safari(let url):
            return AnyView(SafariView(url: url))
        case .about:
            return AnyView(AboutView())
        }
    }
    
    private func makeDateView() -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM"
        let dateString = formatter.string(from: Date())
        return Section(header: SectionHeaderView(text: "Today")) {
            VStack(alignment: .leading) {
                Text(dateString)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.text)
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
                if viewModel.turnipsPredictions!.todayAverages?.isEmpty == true {
                    Text("Today is sunday, don't forget to buy more turnips and fill your buy price")
                } else {
                    Text("Today average buy prices should be ") +
                        Text("\(viewModel.turnipsPredictions!.todayAverages![0])")
                            .foregroundColor(.bell)
                            .fontWeight(.semibold) +
                        Text(" for this morning and ") +
                        Text("\(viewModel.turnipsPredictions!.todayAverages![1])")
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
                if viewModel.turnipsPredictions?.todayAverages != nil {
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
            .onAppear(perform: viewModel.fetchListings)
            .onAppear(perform: viewModel.fetchIsland)
            .onAppear(perform: villagersViewModel.fetch)
            .navigationBarTitle("Dashboard")
            .navigationBarItems(leading: aboutButton,
                                trailing: preferenceButton)
            ActiveCrittersView(activeFishes: viewModel.fishes.filterActive(),
                               activeBugs: viewModel.bugs.filterActive())
        }
        .sheet(item: $selectedSheet, content: makeSheet)
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
