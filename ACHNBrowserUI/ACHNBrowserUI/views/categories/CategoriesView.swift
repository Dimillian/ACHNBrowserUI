//
//  CategoriesView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 11/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CategoriesView: View {
    // MARK: - Vars
    let categories: [Backend.Category]
    
    @EnvironmentObject var items: Items
    @ObservedObject var viewModel = CategoriesSearchViewModel()
    @State var isLoadingData = false

    // MARK: - Computed vars
    private var searchCategories: [(Backend.Category, [Item])] {
        viewModel.searchResults
            .map { $0 }
            .sorted(by: \.key.rawValue)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Section(header: SearchField(searchText: $viewModel.searchText)) {
                        if viewModel.searchText.isEmpty {
                            makeSubCategories(name: "Nature",
                                              icon: Backend.Category.fossils.iconName(),
                                              categories: Backend.Category.nature())
                            makeSubCategories(name: "Wardrobe",
                                              icon: Backend.Category.dressup.iconName(),
                                              categories: Backend.Category.wardrobe())
                            makeCategories()
                        } else {
                            if viewModel.isLoadingData {
                                RowLoadingView(isLoading: $isLoadingData)
                            } else if searchCategories.isEmpty {
                                Text("No results for \(viewModel.searchText)")
                                    .foregroundColor(.acSecondaryText)
                            } else {
                                ForEach(searchCategories, id: \.0, content: searchSection)
                            }
                        }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Catalog"), displayMode: .automatic)
            .onReceive(viewModel.$isLoadingData) { self.isLoadingData = $0 }
            .modifier(DismissingKeyboardOnSwipe())
      
            
            ItemsListView(viewModel: ItemsViewModel(category: .housewares))
        }
    }
}

// MARK: - Views
extension CategoriesView {
    private func makeCategories() -> some View {
        ForEach(categories, id: \.self) { categorie in
            CategoryRowView(category: categorie)
        }
    }
    
    private func makeSubCategories(name: String, icon: String, categories: [Backend.Category]) -> some View {
        NavigationLink(destination: CategoryDetailView(categories: categories)
            .navigationBarTitle(name)) {
                HStack {
                    Image(icon)
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 46, height: 46)
                    Text(LocalizedStringKey(name))
                        .style(appStyle: .rowTitle)
                    Spacer()
                    Text("\(items.itemsCount(for: categories))")
                        .style(appStyle: .rowDescription)
                }
        }
    }

    private func searchSection(category: Backend.Category, items: [Item]) -> some View {
        Section(header: CategoryHeaderView(category: category)) {
            ForEach(items, content: self.searchItemRow)
        }
    }
    
    private func searchItemRow(item: Item) -> some View {
        NavigationLink(destination: ItemDetailView(item: item)) {
            ItemRowView(displayMode: .large, item: item)
        }
    }
}

// MARK: - Previews
struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categories: Category.items())
    }
}
