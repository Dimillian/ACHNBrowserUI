//
//  ActiveCrittersView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct ActiveCritterSections: View {
    @ObservedObject var viewModel: ActiveCrittersViewModel
    @Binding var selectedTab: ActiveCrittersViewModel.CritterType
    
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
                                     critters: viewModel.crittersInfo[selectedTab]?.new ?? [])
            makeSectionOrPlaceholder(title: "To catch",
                                     icon: "calendar",
                                     critters: viewModel.crittersInfo[selectedTab]?.toCatch ?? [])
            makeSectionOrPlaceholder(title: "Leaving this month",
                                     icon: "calendar.badge.minus",
                                     critters: viewModel.crittersInfo[selectedTab]?.leaving ?? [])
            Section(header: SectionHeaderView(text: "Caught",
                                              icon: "tray.2"))
            {
                ForEach(viewModel.crittersInfo[selectedTab]?.caught ?? [],
                        content: sectionContent)
            }
        }
    }
}

struct ActiveCrittersView: View {
    @ObservedObject private var viewModel = ActiveCrittersViewModel(filterOutInCollection: true)
    @State private var selectedTab = ActiveCrittersViewModel.CritterType.fish
    
    var body: some View {
        List {
            if (viewModel.crittersInfo[.fish]?.toCatch.isEmpty == true || viewModel.crittersInfo[.bugs]?.toCatch.isEmpty == true) &&
                (viewModel.crittersInfo[.fish]?.caught.isEmpty == true || viewModel.crittersInfo[.bugs]?.caught.isEmpty == true) {
                RowLoadingView(isLoading: .constant(true))
            } else {
                Picker(selection: $selectedTab, label: Text("")) {
                    ForEach(ActiveCrittersViewModel.CritterType.allCases, id: \.self)
                    { tab in
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
