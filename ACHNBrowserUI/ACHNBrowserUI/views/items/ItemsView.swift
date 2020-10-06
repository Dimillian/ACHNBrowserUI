//
//  ContentView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend
import UI

struct ItemsView: View {
    enum ContentMode {
        case listLarge, listSmall, grid
        
        func iconName() -> String {
            switch self {
            case .listLarge:
                return "rectangle.grid.1x2"
            case .listSmall:
                return "list.dash"
            case .grid:
                return "square.grid.3x2.fill"
            }
        }
    }
    
    @StateObject var viewModel: ItemsViewModel
    @State private var contentMode: ContentMode = .listLarge
    let customTitle: String?
    
    init(category: Backend.Category, items: [Item]? = nil, keyword: String? = nil) {
        if let items = items {
            _viewModel = StateObject(wrappedValue: ItemsViewModel(category: category, items: items))
            customTitle = nil
        } else if let keyword = keyword {
            _viewModel = StateObject(wrappedValue: ItemsViewModel(meta: keyword))
            customTitle = keyword
        } else {
            _viewModel = StateObject(wrappedValue: ItemsViewModel(category: category))
            customTitle = nil
        }
    }
    
    private var sortButton: some View {
        Menu {
            ForEach(ItemsViewModel.Sort.allCases(for: viewModel.category), id: \.self) { sort in
                Button(LocalizedStringKey(sort.rawValue.localizedCapitalized),
                            action:  {
                                self.viewModel.sort = sort
                })
            }
            if viewModel.sort != nil {
                Divider()
                Button("Clear Selection", action: {
                    self.viewModel.sort = nil
                })
            }
        } label:  {
            Button(action: {
                
            }) {
                Image(systemName: viewModel.sort == nil ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                    .style(appStyle: .barButton)
                    .foregroundColor(.acText)
            }
            .buttonStyle(BorderedBarButtonStyle())
            .accentColor(Color.acText.opacity(0.2))
            .safeHoverEffectBarItem(position: .trailing)
        }

    }
    
    private var layoutButton: some View {
        Button(action: {
            switch contentMode {
            case .listLarge:
                contentMode = .listSmall
            case .listSmall:
                contentMode = .grid
            case .grid:
                contentMode = .listLarge
            }
        }) {
            Image(systemName: contentMode.iconName())
                .style(appStyle: .barButton)
                .foregroundColor(.acText)
        }
        .buttonStyle(BorderedBarButtonStyle())
        .accentColor(Color.acText.opacity(0.2))
        .safeHoverEffectBarItem(position: .trailing)
    }
        
    var body: some View {
        contentView
        .modifier(DismissingKeyboardOnSwipe())
        .navigationBarTitleDisplayMode(contentMode == .grid ? .inline : .automatic)
        .navigationBarTitle(customTitle != nil ?
            Text(LocalizedStringKey(customTitle!)) :
            Text(viewModel.category.label()),
                            displayMode: .automatic)
            .navigationBarItems(trailing:
                                    HStack {
                                        layoutButton
                                        sortButton
                                    })
    }
    
    @ViewBuilder
    private var contentView: some View {
        if contentMode == .grid {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 16)], spacing: 16) {
                    ForEach(viewModel.items) { item in
                        ItemGridItemView(item: item)
                    }
                }
                .padding(8)
                .background(Color.acBackground)
            }.background(Color.acBackground)
        } else {
            List {
                Section(header: SearchField(searchText: $viewModel.searchText)) {
                    ForEach(viewModel.items) { item in
                        NavigationLink(destination: LazyView(ItemDetailView(item: item))) {
                            ItemRowView(displayMode: contentMode == .listLarge ? .large : .compact,
                                        item: item)
                        }
                        .listRowBackground(Color.acSecondaryBackground)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .id(viewModel.sort)
        }
    }
}

struct ItemsListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemsView(category: .housewares)
            .environmentObject(Items.shared)
            .environmentObject(UserCollection.shared)
    }
}
