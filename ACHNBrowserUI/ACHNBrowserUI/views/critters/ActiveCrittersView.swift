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
    @Environment(\.currentDate) private var currentDate
    @ObservedObject var viewModel: ActiveCrittersViewModel
    @Binding var selectedTab: ActiveCrittersViewModel.CritterType
    
    private func sectionContent(critter: Item) -> some View {
        NavigationLink(destination: ItemDetailView(item: critter)) {
            ItemRowView(displayMode: .large, item: critter)
        }.listRowBackground(Color.acSecondaryBackground)
    }
    
    private func makeSectionOrPlaceholder(title: String, icon: String, critters: [Item]) -> some View {
        Section(header: SectionHeaderView(text: title, icon: icon)) {
            if critters.isEmpty {
                Text("You caught them all!")
                    .font(.body)
                    .fontWeight(.bold)
                    .listRowBackground(Color.acSecondaryBackground)
            } else {
                ForEach(critters, content: sectionContent)
            }
        }
    }
    
    var body: some View {
        Group {
            makeSectionOrPlaceholder(title: "To catch now",
                                     icon: "calendar",
                                     critters: viewModel.crittersInfo[selectedTab]?.toCatchNow ?? [])
            makeSectionOrPlaceholder(title: "To catch later",
                                     icon: "calendar",
                                     critters: viewModel.crittersInfo[selectedTab]?.toCatchLater ?? [])
            makeSectionOrPlaceholder(title: "New this month",
                                     icon: "calendar.badge.plus",
                                     critters: viewModel.crittersInfo[selectedTab]?.new ?? [])
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
        .onAppear {
            viewModel.updateCritters(for: currentDate)
        }
    }
}

struct ActiveCrittersView: View {
    @Environment(\.currentDate) private var currentDate
    @StateObject private var viewModel = ActiveCrittersViewModel(filterOutInCollection: true)
    @State private var selectedTab: ActiveCrittersViewModel.CritterType
        
    init(tab: ActiveCrittersViewModel.CritterType) {
        _selectedTab = State(initialValue: tab)
    }
    
    private func makeList(type: ActiveCrittersViewModel.CritterType) -> some View {
        List {
            if viewModel.isLoading == true {
                RowLoadingView()
            } else {
                ActiveCritterSections(viewModel: viewModel,
                                      selectedTab: .constant(type))
                    .padding(.top, 16)
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            makeList(type: .fish)
                .tabItem {
                    Image("book-fish-icon")
                }
                .tag(ActiveCrittersViewModel.CritterType.fish)
            
            makeList(type: .bugs)
                .tabItem {
                    Image("book-insect-icon")
                }
                .tag(ActiveCrittersViewModel.CritterType.bugs)
            
            makeList(type: .seaCreatures)
                .tabItem {
                    Image("book-dive-icon")
                }
                .tag(ActiveCrittersViewModel.CritterType.seaCreatures)
        }
        .background(Color.acBackground)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .navigationBarTitle("Active Critters", displayMode: .inline)
        .onAppear {
            viewModel.updateCritters(for: currentDate)
        }
    }
}

struct ActiveCrittersView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCrittersView(tab: .fish)
    }
}
