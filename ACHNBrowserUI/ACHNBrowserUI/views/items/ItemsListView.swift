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
            Image(systemName: viewModel.sort == nil ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                .font(.title)
        }
    }
    
    private var sortSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        for sort in ItemsViewModel.Sort.allCases {
            buttons.append(.default(Text(sort.rawValue.localizedCapitalized),
                                    action: {
                                        self.viewModel.sort = sort
            }))
        }
        
        if viewModel.sort != nil {
            buttons.append(.default(Text("Clear Selection"), action: {
                self.viewModel.sort = nil
                self.viewModel.fetch()
            }))
        }
        
        buttons.append(.cancel())
        
        let title = Text("Sort items")
        
        if let currentSort = viewModel.sort {
            return ActionSheet(title: title,
                               message: Text("Current Sort: \(currentSort.rawValue.localizedCapitalized)"),
                               buttons: buttons)
        }
        
        return ActionSheet(title: title, buttons: buttons)
    }
    
    func makeDetailView() -> some View {
        Text("Please choose an item.")
            .foregroundColor(.secondary)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color.dialogue)
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $viewModel.searchText).listRowBackground(Color.grass)
                    .foregroundColor(.white)
                ForEach(currentItems) { item in
                    NavigationLink(destination: ItemDetailView(item: item,
                                                               viewModel: self.viewModel)) {
                        ItemRowView(item: item)
                            .listRowBackground(Color.dialogue)
                    }
                }
            }
            .id(viewModel.sort)
            .background(Color.dialogue)
            .navigationBarItems(leading: sortButton, trailing: filterButton)
            .navigationBarTitle(Text(viewModel.categorie.rawValue.capitalized),
                                displayMode: .inline)
            .sheet(isPresented: $showFilterSheet, content: { CategoriesView(categories: self.categories,
                                                                            selectedCategory: self.$viewModel.categorie) })
            .actionSheet(isPresented: $showSortSheet, content: { self.sortSheet })
            makeDetailView()
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
