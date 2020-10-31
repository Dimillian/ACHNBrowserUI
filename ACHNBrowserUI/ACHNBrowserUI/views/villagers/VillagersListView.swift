//
//  VillagersListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct VillagersListView: View {
    private enum Filter: String, CaseIterable {
        case all, liked, residents
    }

    @Environment(\.currentDate) private static var currentDate
    @StateObject var viewModel = VillagersViewModel(currentDate: Self.currentDate)
    @State private var currentFilter = Filter.all
    
    var currentVillagers: [Villager] {
        get {
            if currentFilter == .all {
                if !viewModel.searchText.isEmpty {
                    return viewModel.searchResults
                } else if viewModel.sort != nil {
                    return viewModel.sortedVillagers
                } else {
                    return viewModel.villagers
                }
            } else if currentFilter == .residents {
                return viewModel.residents
            } else if currentFilter == .liked {
                return viewModel.liked
            } else {
                return []
            }
        }
    }
        
    var body: some View {
        NavigationView {
            List {
                Section(header: SearchField(searchText: $viewModel.searchText,
                                             placeholder: "Search a villager"))
                {
                    Picker("segment", selection: $currentFilter) {
                        ForEach(Filter.allCases, id: \.self) {
                            Text(LocalizedStringKey($0.rawValue.capitalized))
                        }
                    }.pickerStyle(SegmentedPickerStyle())
                    .listRowBackground(Color.acSecondaryBackground)
                    
                    ForEach(currentVillagers) { villager in
                        NavigationLink(destination: VillagerDetailView(villager: villager)) {
                            self.makeRowView(villager: villager)
                        }
                        .listRowBackground(Color.acSecondaryBackground)
                    }
                }
            }.gesture(DragGesture()
                .onEnded { value in
                    if value.translation.width > 100 {
                        switch(self.currentFilter) {
                        case .liked:
                            self.currentFilter = Filter.all
                        case .residents:
                            self.currentFilter = Filter.liked
                        default: break
                        }
                    }
                    else if value.translation.width < -100 {
                        switch(self.currentFilter) {
                        case .all:
                            self.currentFilter = Filter.liked
                        case .liked:
                            self.currentFilter = Filter.residents
                        default: break
                        }
                    }
                })
            .listStyle(GroupedListStyle())
            .id(viewModel.sort?.rawValue ?? currentFilter.rawValue)
            .navigationBarTitle(Text("Villagers"),
                                displayMode: .automatic)
            .navigationBarItems(trailing:
                Group {
                    if self.currentFilter == .all {
                        HStack(spacing: 12) {
                            VillagersSortView(sort: $viewModel.sort)
                        }
                    }
                })
            .modifier(DismissingKeyboardOnSwipe())
            if !viewModel.villagers.isEmpty {
                VillagerDetailView(villager: viewModel.villagers.first!)
            } else {
                List {
                    RowLoadingView()
                }
            }
        }
    }

    // MARK: - Private

    private func makeRowView(villager: Villager) -> some View {
        let style: VillagerRowView.Style

        switch viewModel.sort {
        case .species: style = .species
        case .personality: style = .personality
        default: style = .none
        }

        return VillagerRowView(villager: villager, style: style, action: currentFilter == .residents ? .home : .like)
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
