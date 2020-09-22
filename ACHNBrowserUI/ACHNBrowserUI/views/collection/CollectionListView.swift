//
//  CollectionListView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

enum Tabs: String, CaseIterable {
    case items, lists, more
}

struct CollectionListView: View {
    @EnvironmentObject private var collection: UserCollection
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
    @State private var selectedTab: Tabs = .items
    @State private var sheet: Sheet.SheetType?

    private var categories: [String] {
        Array(Set(collection.items.map(\.category))).sorted()
    }

    var body: some View {
        NavigationView {
            List {
                Section(header: picker) {
                    if selectedTab == .items && !collection.items.isEmpty {
                        ForEach(categories, id: \.self) { category in
                            CollectionRowView(category: Category(itemCategory: category))
                                .listRowBackground(Color.acSecondaryBackground)
                        }
                    } else if selectedTab == .lists {
                        userListsSections
                    } else if selectedTab == .more {
                        CollectionMoreDetailView(viewModel: CollectionMoreDetailViewModel())
                            .listRowBackground(Color.acSecondaryBackground)
                    } else {
                        emptyView
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle(Text("Collection"),
                                displayMode: .automatic)
            .sheet(item: $sheet, content: { Sheet(sheetType: $0) })
            
            if categories.isEmpty {
                List {
                    placeholderView
                }
            } else {
                ItemsView(category: Category(itemCategory: categories.first!),
                              items: collection.items
                                .filter({ Backend.Category(itemCategory: $0.category) == Category(itemCategory: categories.first!)}))
            }
        }
    }

    private var userListsSections: some View {
        Group {
            if subscriptionManager.subscriptionStatus == .subscribed || collection.lists.isEmpty {
                Button(action: {
                    self.sheet = .userListForm(editingList: nil)
                }) {
                    Text("Create a new list").foregroundColor(.acHeaderBackground)
                }
                .listRowBackground(Color.acSecondaryBackground)
            }
            ForEach(collection.lists) { list in
                NavigationLink(destination: UserListDetailView(list: list)) {
                    UserListRow(list: list)
                }
                .listRowBackground(Color.acSecondaryBackground)
            }.onDelete { indexes in
                self.collection.deleteList(at: indexes.first!)
            }
            if subscriptionManager.subscriptionStatus != .subscribed && collection.lists.count >= 1 {
                UserListSubscribeCallView(sheet: $sheet)
                    .listRowBackground(Color.acSecondaryBackground)
            }
        }
    }

    private var placeholderView: some View {
        Text("Please select or go stars some items!")
            .foregroundColor(.acSecondaryText)
    }

    private var emptyView: some View {
        MessageView(collectionName: selectedTab.rawValue).listRowBackground(Color.acBackground)
    }

    private var picker: some View {
        Picker(selection: $selectedTab, label: Text("")) {
            ForEach(Tabs.allCases, id: \.self) { tab in
                Text(LocalizedStringKey(tab.rawValue.capitalized))
                    .textCase(nil)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding()
    }
}

struct CollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionListView()
        }
        .environmentObject(UserCollection.shared)
        .environmentObject(SubscriptionManager.shared)
    }
}
