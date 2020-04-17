//
//  ContentView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemsListView: View {
    @ObservedObject private var viewModel = ItemsViewModel(categorie: .housewares)
    @State private var showFilterSheet = false
    @State private var showSortSheet = false
    
    var currentItems: [Item] {
        get {
            if !viewModel.searchText.isEmpty {
                return viewModel.searchItems
            } else if viewModel.sort != nil {
                return viewModel.sortedItems
            } else {
                return viewModel.items
            }
        }
    }
    
    let categories: [Categories]
    
    private var filterButton: some View {
        Button(action: {
            self.showFilterSheet.toggle()
        }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
                .font(.title)
        }
    }
    
    private var sortButton: some View {
        Button(action: {
            self.showSortSheet.toggle()
        }) {
            Image(systemName: "arrow.up.arrow.down.circle")
                .font(.title)
        }
    }
    
    private var sortSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        for sort in ItemsViewModel.Sort.allCases {
            buttons.append(.default(Text(sort.rawValue.capitalized),
                                    action: {
                                        self.viewModel.sort = sort
            }))
        }
        buttons.append(.default(Text("Remove filter"), action: {
            self.viewModel.sort = nil
            self.viewModel.fetch()
        }))
        buttons.append(.cancel())
        return ActionSheet(title: Text("Sort items"), buttons: buttons)
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $viewModel.searchText).listRowBackground(Color.grass)
                ForEach(currentItems) { item in
                    NavigationLink(destination: ItemDetailView(item: item,
                                                               viewModel: self.viewModel,
                                                               listingsViewModel: ItemDetailViewModel(item: item))) {
                        ItemRowView(item: item)
                            .environmentObject(ItemDetailViewModel(item: item))
                            .listRowBackground(Color.dialogue)
                    }
                }
            }
            .background(Color.dialogue)
            .navigationBarItems(leading: sortButton, trailing: filterButton)
            .navigationBarTitle(Text(viewModel.categorie.rawValue.capitalized),
                                displayMode: .inline)
            .sheet(isPresented: $showFilterSheet, content: { CategoriesView(categories: self.categories,
                                                                            selectedCategory: self.$viewModel.categorie) })
            .actionSheet(isPresented: $showSortSheet, content: { self.sortSheet })
        }.onAppear {
            self.viewModel.categorie = self.categories.first!
        }
    }
}

struct ItemsListViewPreviews: PreviewProvider {
    static var previews: some View {
        ItemsListView(categories: Categories.items())
            .environmentObject(Collection())
    }
}
