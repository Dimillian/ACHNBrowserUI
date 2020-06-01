//
//  ActiveCrittersView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

enum Tab: String, CaseIterable {
    case fishes = "Fishes"
    case bugs = "Bugs"
}

struct ActiveCritterSections: View {
    @ObservedObject var viewModel: ActiveCrittersViewModel
    @Binding var selectedTab: Tab
    
    private func sectionContent(critter: Item) -> some View {
        NavigationLink(destination: ItemDetailView(item: critter)) {
            ItemRowView(displayMode: .large, item: critter)
        }
    }
    
    private func makeSectionOrPlaceholder(title: String, icon: String, critters: [Item]) -> some View {
        Section(header: SectionHeaderView(text: title, icon: icon)) {
            if critters.isEmpty {
                Text("You caught them all!").font(.body).fontWeight(.bold)
            } else {
                ForEach(critters, content: sectionContent)
            }
        }
    }
    
    var body: some View {
        Group {
            makeSectionOrPlaceholder(title: "New this month",
                                     icon: "calendar.badge.plus",
                                     critters: selectedTab == .fishes ? viewModel.newFishThisMonth : viewModel.newBugsThisMonth)
            makeSectionOrPlaceholder(title: "To catch",
                                     icon: "calendar",
                                     critters: selectedTab == .fishes ? viewModel.toCatchFish : viewModel.toCatchBugs)
            makeSectionOrPlaceholder(title: "Leaving this month",
                                     icon: "calendar.badge.minus",
                                     critters: selectedTab == .fishes ? viewModel.leavingFishThisMonth : viewModel.leavingBugsThisMonth)
            Section(header: SectionHeaderView(text: "Caught",
                                              icon: "tray.2"))
            {
                ForEach(selectedTab == .fishes ? viewModel.caughFish : viewModel.caughBugs,
                        content: sectionContent)
            }
        }
    }
}

struct ActiveCrittersView: View {
    @ObservedObject private var viewModel = ActiveCrittersViewModel(filterOutInCollection: true)
    @State private var selectedTab = Tab.fishes
    
    var body: some View {
        List {
            if (viewModel.activeFish.isEmpty || viewModel.activeBugs.isEmpty) &&
                (viewModel.caughBugs.isEmpty || viewModel.caughFish.isEmpty) {
                RowLoadingView(isLoading: .constant(true))
            } else {
                Picker(selection: $selectedTab, label: Text("")) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Text(LocalizedStringKey(tab.rawValue)).tag(tab.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .listRowBackground(Color.acBackground)
                ActiveCritterSections(viewModel: viewModel, selectedTab: $selectedTab)
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Active Critters")
    }
}

struct ActiveCrittersView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCrittersView()
    }
}
