//
//  UserListDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct UserListDetailView: View {
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject private var viewModel: UserListDetailViewModel
    @ObservedObject private var searchViewModel = CategoriesSearchViewModel()
    @State private var isLoadingData = false
    @State private var sheet: Sheet.SheetType?
    
    init(list: UserList) {
        self.viewModel = UserListDetailViewModel(list: list)
    }
    
    private var searchCategories: [(Backend.Category, [Item])] {
        searchViewModel.searchResults
            .map { $0 }
            .sorted(by: \.key.rawValue)
    }
    
    private var activeBarButton: some View {
        Group {
            if !searchViewModel.searchText.isEmpty && !viewModel.selectedItems.isEmpty {
                addButton
            } else {
                editButton
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            self.viewModel.saveItems()
            self.searchViewModel.searchText = ""
        }) {
            Text("Add \(viewModel.selectedItems.count) items")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.acHeaderBackground)
        }
    }
    
    private var editButton: some View {
        Button(action: {
            self.sheet = .userListForm(editingList: self.viewModel.list)
        }) {
            Text("Edit").foregroundColor(.acHeaderBackground)
        }
    }
    
    private var searchBar: some View {
        SearchField(searchText: $searchViewModel.searchText, placeholder: "Search items")
    }
    
    var body: some View {
        List {
            Section(header: searchBar) {
                if searchViewModel.searchText.isEmpty {
                    if !viewModel.list.items.isEmpty {
                        ForEach(viewModel.list.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(displayMode: .largeNoButton, item: item)
                            }
                            .listRowBackground(Color.acSecondaryBackground)
                        }.onDelete { indexes in
                            self.viewModel.deleteItem(at: indexes.first!)
                        }
                    } else {
                        MessageView("Items added to your list from the search will be displayed there.")
                            .listRowBackground(Color.acSecondaryBackground)
                    }
                } else {
                    if searchViewModel.isLoadingData {
                        RowLoadingView().animation(.default)
                    } else if searchCategories.isEmpty {
                        MessageView(noResultsFor: searchViewModel.searchText)
                            .listRowBackground(Color.acSecondaryBackground)
                    } else {
                        ForEach(searchCategories, id: \.0, content: searchSection)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.editMode, .constant(!searchViewModel.searchText.isEmpty ? .active : .inactive))
        .onReceive(searchViewModel.$isLoadingData) { self.isLoadingData = $0 }
        .navigationBarTitle(Text(viewModel.list.name))
        .navigationBarItems(trailing: activeBarButton)
        .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
    }
    
    private func searchSection(category: Backend.Category, items: [Item]) -> some View {
        Group {
            CategoryHeaderView(category: category).listRowBackground(Color.acBackground)
            ForEach(items, content: self.searchItemRow)
        }
    }
    
    private func isSearchedItemSelected(item: Item) -> Bool {
        viewModel.selectedItems.contains(item) || viewModel.list.items.contains(item)
    }
    
    
    private func searchItemRow(item: Item) -> some View {
        ItemRowView(displayMode: .largeNoButton, item: item)
            .listRowBackground(isSearchedItemSelected(item: item) ?
                Color.graphAverage :
                Color.acSecondaryBackground)
            .onTapGesture {
                if self.isSearchedItemSelected(item: item) {
                    if let index = self.viewModel.list.items.firstIndex(of: item) {
                        self.viewModel.deleteItem(at: index)
                    }
                    self.viewModel.selectedItems.removeAll(where: { $0 == item })
                } else {
                    self.viewModel.selectedItems.append(item)
                }
        }
    }
    
}
