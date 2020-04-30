//
//  VillagersListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

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
    
    private var loadingView: some View {
        Text("Loading...")
            .foregroundColor(.secondary)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.dialogue)
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $viewModel.searchText,
                            placeholder: "Search a villager")
                ForEach(currentVillagers) { villager in
                    NavigationLink(destination: VillagerDetailView(villager: villager)) {
                        VillagerRowView(villager: villager)
                    }
                }
            }
            .onAppear(perform: viewModel.fetch)
            .background(Color.dialogue)
            .navigationBarTitle(Text("Villagers"),
                                displayMode: .inline)
            .modifier(DismissingKeyboardOnSwipe())
            if !viewModel.villagers.isEmpty {
                VillagerDetailView(villager: viewModel.villagers.first!)
            } else {
                loadingView
            }
        }
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
