//
//  ContentView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemsListView: View {
    @ObservedObject var viewModel = ItemsViewModel()
    @State private var showFilterSheet = false
    
    private var filterButton: some View {
        Button(action: {
            self.showFilterSheet.toggle()
        }) {
            Image(systemName: "line.horizontal.3.decrease.circle")
                .font(.title)
        }
    }
    
    private var filterSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        for filter in APIService.Endpoint.allCases {
            buttons.append(.default(Text(filter.rawValue),
                                    action: {
                                        self.viewModel.currentFilter = filter
            }))
        }
        buttons.append(.cancel())
        return ActionSheet(title: Text("Filter items"), buttons: buttons)
    }
    
    var body: some View {
        NavigationView {
            List {
                SearchField(searchText: $viewModel.searchText)
                ForEach(!viewModel.searchText.isEmpty ? viewModel.searchItems : viewModel.items) { item in
                    HStack(spacing: 8) {
                        ItemImage(imageLoader: ImageLoader(path: item.image))
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name).font(.headline)
                            Text(item.obtainedFrom ?? "unknown source").font(.subheadline)
                            HStack(spacing: 4) {
                                if item.buy != nil {
                                    Text("Buy for: \(item.buy!)").font(.caption)
                                }
                                if item.sell != nil {
                                    Text("Sell for: \(item.sell!)").font(.caption)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarItems(trailing: filterButton
                .actionSheet(isPresented: $showFilterSheet, content: { filterSheet }))
            .navigationBarTitle(viewModel.currentFilter.rawValue.capitalized)
        }.onAppear {
            self.viewModel.fetch()
        }
    }
}
