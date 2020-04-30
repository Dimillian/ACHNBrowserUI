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
        case safari(URL), settings
        
        var id: String {
            switch self {
            case .safari(let url):
                return url.absoluteString
            case .settings:
                return "settings"
            }
        }
    }
    
    
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject private var viewModel = DashboardViewModel()
    @ObservedObject private var villagersViewModel = VillagersViewModel()
    @State var selectedSheet: Sheet?
    
    private var preferenceButton: some View {
        Button(action: {
            self.selectedSheet = .settings
        }, label: {
            Image(systemName: "wrench").imageScale(.medium)
        })
    }
    
    func makeSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .settings:
            return AnyView(SettingsView())
        case .safari(let url):
            return AnyView(SafariView(url: url))
        }
    }
    
    func makeDateView() -> some View {
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
    
    func makeBirthdayView() -> some View {
        Section(header: SectionHeaderView(text: "Villager birthday")) {
            ForEach(villagersViewModel.todayBirthdays) { villager in
                NavigationLink(destination: VillagerDetailView(villager: villager),
                               label: {
                                VillagerRowView(villager: villager)
                })
            }
        }
    }
    
    func makeTopTurnipSection() -> some View {
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
                makeTopTurnipSection()
                DashboardNookazonListingSection(selectedSheet: $selectedSheet, viewModel: viewModel)
            }
            .listStyle(GroupedListStyle())
            .onAppear(perform: viewModel.fetchListings)
            .onAppear(perform: viewModel.fetchIsland)
            .onAppear(perform: villagersViewModel.fetch)
            .navigationBarItems(trailing: preferenceButton)
            .navigationBarTitle("Dashboard",
                                displayMode: .inline)
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
