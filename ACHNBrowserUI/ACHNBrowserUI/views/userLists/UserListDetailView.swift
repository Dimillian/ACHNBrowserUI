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
    @ObservedObject private var viewModel: UserListDetailViewModel
    @ObservedObject private var searchViewModdel = CategoriesSearchViewModel()
    @State private var isLoadingData = false
    @State private var sheet: Sheet.SheetType?
    
    init(list: UserList) {
        self.viewModel = UserListDetailViewModel(list: list)
    }
    
    private var searchCategories: [(Backend.Category, [Item])] {
        searchViewModdel.searchResults
            .map { $0 }
            .sorted(by: \.key.rawValue)
    }
    
    private var addButton: some View {
        Button(action: {
            self.viewModel.saveItems()
            self.searchViewModdel.searchText = ""
        }) {
            Text("Add \(viewModel.selectedItems.count) items")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.bell)
        }
    }
    
    private var editButton: some View {
        Button(action: {
            self.sheet = .userListForm(editingList: self.viewModel.list)
        }) {
            Text("Edit").foregroundColor(.bell)
        }
    }
    
    private var searchBar: some View {
        HStack {
            SearchField(searchText: $searchViewModdel.searchText, placeholder: "Search Items")
            if viewModel.selectedItems.count > 0 {
                addButton
            }
        }.animation(.spring())
    }
    
    var body: some View {
        List {
            Section(header: searchBar) {
                if searchViewModdel.searchText.isEmpty {
                    if !viewModel.list.items.isEmpty {
                        ForEach(viewModel.list.items) { item in
                            NavigationLink(destination: ItemDetailView(item: item)) {
                                ItemRowView(displayMode: .largeNoButton, item: item)
                            }
                        }.onDelete { indexes in
                            self.viewModel.deleteItem(at: indexes.first!)
                        }
                    } else {
                        Text("Search some items to add to your list")
                            .foregroundColor(.secondaryText)
                    }
                } else {
                    if searchViewModdel.isLoadingData {
                        RowLoadingView(isLoading: $isLoadingData).animation(.default)
                    } else if searchCategories.isEmpty {
                        Text("No results for \(searchViewModdel.searchText)")
                            .foregroundColor(.secondaryText)
                    } else {
                        ForEach(searchCategories, id: \.0, content: searchSection)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .environment(\.editMode, .constant(!searchViewModdel.searchText.isEmpty ? .active : .inactive))
        .onReceive(searchViewModdel.$isLoadingData) { self.isLoadingData = $0 }
        .navigationBarTitle(Text(viewModel.list.name))
        .navigationBarItems(trailing: editButton)
        .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
    }
    
    private func searchSection(category: Backend.Category, items: [Item]) -> some View {
        Section(header: CategoryHeaderView(category: category)) {
            ForEach(items, content: self.searchItemRow)
        }
    }
    
    
    private func searchItemRow(item: Item) -> some View {
        ZStack {
            ItemRowView(displayMode: .largeNoButton, item: item)
                .listRowBackground(self.viewModel.selectedItems.contains(item) ? Color.graphAverage : Color.dialogue)
        }.onTapGesture {
            if self.viewModel.selectedItems.contains(item) {
                self.viewModel.selectedItems.removeAll(where: { $0 == item })
            } else {
                self.viewModel.selectedItems.append(item)
            }
        }
    }
    
}
