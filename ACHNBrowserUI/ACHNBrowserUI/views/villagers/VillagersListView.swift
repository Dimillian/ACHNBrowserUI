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
    @ObservedObject var viewModel = VillagersViewModel()
    
    var currentVillagers: [Villager] {
        get {
            if !viewModel.searchText.isEmpty {
                return viewModel.searchResults
            } else if viewModel.sort != nil {
                return viewModel.sortedVillagers
            } else {
                return viewModel.villagers
            }
        }
    }
        
    var body: some View {
        NavigationView {
            List {
                Section(header: SearchField(searchText: $viewModel.searchText,
                                            placeholder: "Search a villager"))
                {
                    ForEach(currentVillagers) { villager in
                        NavigationLink(destination: VillagerDetailView(villager: villager)) {
                            self.makeRowView(villager: villager)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .id(viewModel.sort)
            .navigationBarTitle(Text("Villagers"),
                                displayMode: .automatic)
                .navigationBarItems(trailing:
                    HStack(spacing: 12) {
                        VillagersSortView(sort: $viewModel.sort)
                })
            .modifier(DismissingKeyboardOnSwipe())
            if !viewModel.villagers.isEmpty {
                VillagerDetailView(villager: viewModel.villagers.first!)
            } else {
                List {
                    RowLoadingView(isLoading: .constant(true))
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

        return VillagerRowView(villager: villager, style: style)
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
