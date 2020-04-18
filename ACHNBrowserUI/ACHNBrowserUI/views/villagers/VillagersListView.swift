//
//  VillagersListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

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
    
    private var placeholderView: some View {
        Text("Please choose a villager.")
            .foregroundColor(.secondary)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.dialogue)
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $viewModel.searchText,
                            placeholder: "Search a villager")
                    .listRowBackground(Color.grass)
                    .foregroundColor(.white)
                ForEach(currentVillagers) { villager in
                    NavigationLink(destination: VillagerDetailView(villager: villager,
                                                                   villagersViewModel: self.viewModel)) {
                                                                    VillagerRowView(villager: villager)
                    }
                }
            }
            .onAppear(perform: viewModel.fetch)
            .background(Color.dialogue)
            .navigationBarTitle(Text("Villagers"),
                                displayMode: .inline)
            placeholderView
        }
    }
}

struct VillagersListView_Previews: PreviewProvider {
    static var previews: some View {
        VillagersListView()
    }
}
