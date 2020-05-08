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
    
    private var searchBar: some View {
        HStack {
            SearchField(searchText: $searchViewModdel.searchText, placeholder: "Search Items")
            if viewModel.selectedItems.count > 0 {
                addButton
            }
        }.animation(.spring())
    }
    
    var body: some View {
        List(selection: $viewModel.selectedItems) {
            Section(header: searchBar) {
                if searchViewModdel.searchText.isEmpty {
                    ForEach(viewModel.list.items) { item in
                        NavigationLink(destination: ItemDetailView(item: item)) {
                            ItemRowView(displayMode: .largeNoButton, item: item)
                        }
                    }.onDelete { indexes in
                        self.viewModel.deleteItem(at: indexes.first!)
                    }
                } else {
                    if searchViewModdel.isLoadingData {
                        loadingView.animation(.default)
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
    }
    
    private var loadingView: some View {
        VStack {
            HStack { Spacer() }
            Spacer()
            ActivityIndicator(isAnimating: $isLoadingData, style: .large)
            Spacer()
        }.background(Color.dialogue)
    }
    
    private func makeSearchCategoryHeader(category: Backend.Category) -> some View {
        HStack {
            Image(category.iconName())
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 30)
            Text(category.label())
                .font(.subheadline)
        }
    }
    
    private func searchSection(category: Backend.Category, items: [Item]) -> some View {
        Section(header: self.makeSearchCategoryHeader(category: category)) {
            ForEach(items, content: self.searchItemRow)
        }
    }
    
    
    private func searchItemRow(item: Item) -> some View {
        NavigationLink(destination: ItemDetailView(item: item)) {
            ItemRowView(displayMode: .largeNoButton, item: item)
        }
    }
    
}
