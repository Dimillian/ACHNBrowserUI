//
//  ItemDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var itemsViewModel: ItemsViewModel
    @ObservedObject var itemViewModel: ItemDetailViewModel
    
    @State private var displayedVariant: String?
    @State private var sheet: Sheets?

    var setItems: [Item] {
        guard let set = itemViewModel.item.set else { return [] }
        return itemsViewModel.items.filter({ $0.set == set })
    }
    
    private var informationSection: some View {
        Section(header: Text("INFORMATION")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                VStack( spacing: 4) {
                    HStack(alignment: .center) {
                        Spacer()
                        if itemViewModel.item.image == nil && displayedVariant == nil {
                            Image(itemViewModel.item.appCategory!.iconName())
                                .resizable()
                                .frame(width: 150, height: 150)
                        } else {
                            ItemImage(path: displayedVariant ?? itemViewModel.item.image,
                                      size: 150)
                        }
                        Spacer()
                    }
                    if itemViewModel.item.obtainedFrom != nil {
                        Text(itemViewModel.item.obtainedFrom!)
                            .foregroundColor(.secondaryText)
                    }
                    Text("Customizable: \(itemViewModel.item.customize == true ? "Yes" : "no")")
                        .foregroundColor(.text)
                    HStack(spacing: 16) {
                        if itemViewModel.item.sell != nil {
                            HStack(spacing: 2) {
                                Image("icon-bells")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("\(itemViewModel.item.sell!)")
                                    .foregroundColor(.bell)
                            }
                        }
                        if itemViewModel.item.buy != nil {
                            HStack(spacing: 2) {
                                Image("icon-bell")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("\(itemViewModel.item.buy!)")
                                    .foregroundColor(.bell)
                            }
                        }
                    }
                }
        }
    }
    
    private var variantsSection: some View {
        Section(header: Text("VARIANTS")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(itemViewModel.item.variants!, id: \.self) { variant in
                            ItemImage(path: variant,
                                      size: 75)
                                .onTapGesture {
                                    withAnimation {
                                        self.displayedVariant = variant
                                    }
                            }
                        }
                    }
                }
        }
    }
    
    private var materialsSection: some View {
        Section(header: Text("MATERIALS")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(itemViewModel.item.materials!) { material in
                            VStack {
                                if material.iconName != nil {
                                    Image(material.iconName!)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                }
                                Text(material.itemName)
                                    .font(.callout)
                                    .foregroundColor(.text)
                                Text("\(material.count)")
                                    .font(.footnote)
                                    .foregroundColor(.bell)
                                
                            }
                        }
                    }
                }
        }
    }
    
    private var setSection: some View {
        Section(header: Text("SET ITEMS")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(setItems) { item in
                            VStack(alignment: .center, spacing: 4) {
                                ItemImage(path: item.image,
                                          size: 75)
                                Text(item.name)
                                    .font(.caption)
                                    .foregroundColor(.text)
                            }.onTapGesture {
                                self.displayedVariant = nil
                                self.itemViewModel.item = item
                            }
                        }
                    }
                }
        }
    }
    
    enum Sheets: Identifiable {
        case safari(URL)
        
        var id: String {
            "safari"
        }
    }
        
    private var listingSection: some View {
        Section(header: Text("NOOKAZON LISTINGS")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                if itemViewModel.loading {
                    Text("Loading Listings...")
                        .foregroundColor(.secondary)
                }
                if !itemViewModel.listings.isEmpty {
                    ForEach(itemViewModel.listings.filter { $0.active && $0.selling }, content: { listing in
                        Button(action: {
                            self.sheet = .safari(URL(string: "https://nookazon.com/product/\(listing.itemId)")!)
                        }) {
                            ListingRow(listing: listing)
                        }
                    })
                }
        }
    }
    
    func makeSheet(_ sheet: Sheets) -> some View {
        switch(sheet) {
        case .safari(let url):
            return SafariView(url: url)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    var body: some View {
        List {
            informationSection
            if itemViewModel.item.variants != nil {
                variantsSection
            }
            if !setItems.isEmpty {
                setSection
            }
            if itemViewModel.item.materials != nil {
                materialsSection
            }
            listingSection
        }
        .listStyle(GroupedListStyle())
        .onAppear(perform: {
            self.itemViewModel.fetch(item: self.itemViewModel.item)
        })
        .onDisappear {
            self.itemViewModel.cancellable?.cancel()
        }
        .navigationBarTitle(Text(itemViewModel.item.name))
        .sheet(item: $sheet, content: makeSheet)
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemDetailView(itemsViewModel: ItemsViewModel(categorie: .housewares),
                           itemViewModel: ItemDetailViewModel(item: static_item))
                .environmentObject(CollectionViewModel())
        }
    }
}
