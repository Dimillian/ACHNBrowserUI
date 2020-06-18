//
//  ContentView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemsListView: View {
    @ObservedObject var viewModel: ItemsViewModel
    @State private var showSortSheet = false
    @State private var itemRowsDisplayMode: ItemRowView.DisplayMode = .large
    let customTitle: String?
    
    init(category: Backend.Category, items: [Item]? = nil, keyword: String? = nil) {
        if let items = items {
            viewModel = ItemsViewModel(category: category, items: items)
            customTitle = nil
        } else if let keyword = keyword {
            viewModel = ItemsViewModel(meta: keyword)
            customTitle = keyword
        } else {
            viewModel = ItemsViewModel(category: category)
            customTitle = nil
        }
    }
    
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
    
    private var sortButton: some View {
        Button(action: {
            self.showSortSheet.toggle()
        }) {
            Image(systemName: viewModel.sort == nil ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                .imageScale(.large)
        }
        .safeHoverEffectBarItem(position: .trailing)
    }
    
    private var layoutButton: some View {
        Button(action: {
            self.itemRowsDisplayMode = self.itemRowsDisplayMode == .compact ? .large : .compact
        }) {
            Image(systemName: itemRowsDisplayMode == .large ? "rectangle.grid.1x2" : "list.dash")
                .imageScale(.large)
        }
        .safeHoverEffectBarItem(position: .trailing)
    }
    
    private var sortSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        for sort in ItemsViewModel.Sort.allCases(for: viewModel.category) {
            buttons.append(.default(Text(LocalizedStringKey(sort.rawValue.localizedCapitalized)),
                                    action: {
                                        self.viewModel.sort = sort
            }))
        }
        
        if viewModel.sort != nil {
            buttons.append(.default(Text("Clear Selection"), action: {
                self.viewModel.sort = nil
            }))
        }
        
        buttons.append(.cancel())
        
        let title = Text("Sort items")
        
        if let currentSort = viewModel.sort {
            let currentSortName = NSLocalizedString(currentSort.rawValue.localizedCapitalized, comment: "")
            return ActionSheet(title: title,
                               message: Text("Current Sort: \(currentSortName)"),
                               buttons: buttons)
        }
        
        return ActionSheet(title: title, buttons: buttons)
    }
    
    var body: some View {
        List {
            Section(header: SearchField(searchText: $viewModel.searchText)) {
                ForEach(currentItems) { item in
                    NavigationLink(destination: LazyView(ItemDetailView(item: item))) {
                        ItemRowView(displayMode: self.itemRowsDisplayMode, item: item)
                            .listRowBackground(Color.acSecondaryBackground)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .id(viewModel.sort)
        .modifier(DismissingKeyboardOnSwipe())
        .navigationBarTitle(customTitle != nil ?
            Text(LocalizedStringKey(customTitle!)) :
            Text(viewModel.category.label()),
                            displayMode: .automatic)
            .navigationBarItems(trailing:
                HStack(spacing: 12) {
                    layoutButton
                    sortButton
                })
        .actionSheet(isPresented: $showSortSheet, content: { self.sortSheet })
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsListView(category: .housewares)
            .environmentObject(Items.shared)
            .environmentObject(UserCollection.shared)
    }
}
