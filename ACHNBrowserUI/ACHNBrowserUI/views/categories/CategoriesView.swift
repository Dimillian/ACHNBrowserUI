//
//  CategoriesView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 11/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct CategoriesView: View {
    // MARK: - Vars
    let categories: [Backend.Category]
    
    @EnvironmentObject private var items: Items
    @StateObject private var viewModel = CategoriesSearchViewModel()
    @State private var isLoadingData = false
    @State private var isNatureExpanded = false
    @State private var isWardrobeExpanded = false

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
                Section(header: SearchField(searchText: $viewModel.searchText).id("searchField")) {
                    if viewModel.searchText.isEmpty {
                        makeSubCategories(isExpanded: $isNatureExpanded,
                                          name: "Nature",
                                          icon: Backend.Category.fossils.iconName(),
                                          categories: Backend.Category.nature())
                        makeSubCategories(isExpanded: $isWardrobeExpanded,
                                          name: "Wardrobe",
                                          icon: Backend.Category.dressup.iconName(),
                                          categories: Backend.Category.wardrobe())
                        makeCategories()
                    } else {
                        if viewModel.isLoadingData {
                            RowLoadingView()
                        } else if searchCategories.isEmpty {
                            Text("No results for \(viewModel.searchText)")
                                .foregroundColor(.acSecondaryText)
                        } else {
                            ForEach(searchCategories, id: \.0, content: searchSection)
                        }
                    }
                }
            }
            .animation(.interactiveSpring())
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Catalog"))
            .onReceive(viewModel.$isLoadingData) { self.isLoadingData = $0 }
            .modifier(DismissingKeyboardOnSwipe())
      
            
            ItemsView(category: .housewares)
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
    
    private func makeSubCategories(isExpanded: Binding<Bool>, name: String, icon: String, categories: [Backend.Category]) -> some View {
        DisclosureGroup(isExpanded: isExpanded,
            content: {
                Section {
                    ForEach(categories, id: \.rawValue) { category in
                        CategoryRowView(category: category)
                    }
                }
            },
            label: {
                Button(action: {
                    isExpanded.wrappedValue.toggle()
                }, label: {
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
                })
            })
            .listRowBackground(Color.acSecondaryBackground)
            .accentColor(.acText)
    }

    private func searchSection(category: Backend.Category, items: [Item]) -> some View {
        Group {
            CategoryHeaderView(category: category).listRowBackground(Color.acBackground)
            ForEach(items, content: self.searchItemRow)
        }
    }
    
    private func searchItemRow(item: Item) -> some View {
        NavigationLink(destination: LazyView(ItemDetailView(item: item))) {
            ItemRowView(displayMode: .large, item: item)
        }.listRowBackground(Color.acSecondaryBackground)
    }
}

// MARK: - Previews
struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categories: Category.items())
            .environmentObject(Items.shared)
    }
}
