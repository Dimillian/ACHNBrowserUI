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
                        NavigationLink(destination: NavigationLazyView(VillagerDetailView(villager: villager))) {
                            VillagerRowView(villager: villager)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Villagers"),
                                displayMode: .automatic)
            .modifier(DismissingKeyboardOnSwipe())
            if !viewModel.villagers.isEmpty {
                VillagerDetailView(villager: viewModel.villagers.first!)
            } else {
                RowLoadingView(isLoading: .constant(true))
            }
        }
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
