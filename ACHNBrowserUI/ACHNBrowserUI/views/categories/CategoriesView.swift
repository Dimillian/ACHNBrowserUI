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
            VStack {
                SearchField(searchText: $viewModel.searchText)
                    .padding(.leading, 8)
                    .padding(.trailing, 8)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    .background(Color.grassBackground)
                if viewModel.searchText.isEmpty {
                    categoriesList
                } else {
                    searchList
                }
            }
            .navigationBarTitle(Text("Catalog"), displayMode: .inline)
            .background(Color.grassBackground)
            .onReceive(viewModel.$isLoadingData) { self.isLoadingData = $0 }
            
            ItemsListView(viewModel: ItemsViewModel(category: .housewares))
        }
    }
}

// MARK: - Views
extension CategoriesView {
    func makeCategories() -> some View {
        ForEach(categories, id: \.self) { categorie in
            CategoryRowView(category: categorie)
        }
    }
    
    func makeWardrobeCell() -> some View {
        NavigationLink(destination: CategoryDetailView(categories: Category.wardrobe())
            .navigationBarTitle("Wardrobe")) {
                HStack {
                    Image(Category.dresses.iconName())
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 46, height: 46)
                    Text("Wardrobe")
                        .font(.headline)
                        .foregroundColor(.text)
                }
        }
    }
    
    func makeNatureCell() -> some View {
        NavigationLink(destination: CategoryDetailView(categories: Category.nature())
            .navigationBarTitle("Nature")) {
                HStack {
                    Image(Category.fossils.iconName())
                        .renderingMode(.original)
                        .resizable()
                        .frame(width: 46, height: 46)
                    Text("Nature")
                        .font(.headline)
                        .foregroundColor(.text)
                }
        }
    }
    
    
    func makeSearchCategoryHeader(category: Backend.Category) -> some View {
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
            ItemRowView(displayMode: .big, item: item)
        }
    }
    
    private var loadingView: some View {
        VStack {
            HStack { Spacer() }
            Spacer()
            ActivityIndicator(isAnimating: $isLoadingData, style: .large)
            Spacer()
        }.background(Color.dialogue)
    }
    
    
    private var categoriesList: some View {
        List {
            makeNatureCell()
            makeWardrobeCell()
            makeCategories()
        }.modifier(DismissingKeyboardOnSwipe())
    }
    
    private var searchList: some View {
        ZStack {
            List {
                ForEach(searchCategories, id: \.0, content: searchSection)
            }
            loadingView
                .opacity(isLoadingData ? 80/100 : 0)
                .animation(.default)
        }.modifier(DismissingKeyboardOnSwipe())
    }
}

// MARK: - Previews
struct CategoriesView_Previews: PreviewProvider {
    static var previews: some View {
        CategoriesView(categories: Category.items())
    }
}
