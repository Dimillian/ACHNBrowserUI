//
//  ItemDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    @ObservedObject var viewModel: ItemsViewModel
    @ObservedObject var listingsViewModel: ItemDetailViewModel
    
    @State private var displayedVariant: String?
    
    var setItems: [Item] {
        guard let set = listingsViewModel.item.set else { return [] }
        return viewModel.items.filter({ $0.set == set })
    }
    
    private var informationSection: some View {
        Section(header: Text("INFORMATION")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                VStack( spacing: 4) {
                    HStack(alignment: .center) {
                        Spacer()
                        if listingsViewModel.item.image == nil && displayedVariant == nil {
                            Image(listingsViewModel.item.appCategory!.iconName())
                                .resizable()
                                .frame(width: 150, height: 150)
                        } else {
                            ItemImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: displayedVariant ?? listingsViewModel.item.image),
                                      size: 150)
                        }
                        Spacer()
                    }
                    if listingsViewModel.item.obtainedFrom != nil {
                        Text(listingsViewModel.item.obtainedFrom!)
                            .foregroundColor(.secondaryText)
                    }
                    Text("Customizable: \(listingsViewModel.item.customize == true ? "Yes" : "no")")
                        .foregroundColor(.text)
                    HStack(spacing: 16) {
                        if listingsViewModel.item.sell != nil {
                            HStack(spacing: 2) {
                                Image("icon-bells")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("\(listingsViewModel.item.sell!)")
                                    .foregroundColor(.bell)
                            }
                        }
                        if listingsViewModel.item.buy != nil {
                            HStack(spacing: 2) {
                                Image("icon-bell")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("\(listingsViewModel.item.buy!)")
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
                        ForEach(listingsViewModel.item.variants!, id: \.self) { variant in
                            ItemImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: variant),
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
                        ForEach(listingsViewModel.item.materials!) { material in
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
                                ItemImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: item.image),
                                          size: 75)
                                Text(item.name)
                                    .font(.caption)
                                    .foregroundColor(.text)
                            }.onTapGesture {
                                self.displayedVariant = nil
                                self.listingsViewModel.item = item
                            }
                        }
                    }
                }
        }
    }
    
    // TODO: Refactor, this is a bit of a mess.
    private func makeListingCell(_ listing: Listing) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 4) {
                listing.prices?.first {
                    $0.name == nil
                    }?.bells.map { bells in
                        Group {
                            Image("icon-bells")
                                .resizable()
                                .frame(width: 25, height: 25)
                            Text("\(bells)")
                        }
                }
            }
            ForEach(listing.prices?.filter {
                $0.bells == nil
            } ?? [], id: \.name) {
                $0.name.map { name in
                    HStack(spacing: 4) {
                        Image("icon-fossil")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text(name)
                    }
                }
            }
            if listing.makeOffer {
                HStack(spacing: 4) {
                    Image("icon-bell")
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text("Make an Offer")
                }
            }
            Text("\(listing.username)\(listing.discord.map { " · \($0)" } ?? "")")
                .font(.subheadline)
        }
        .font(.headline)
    }
    
    private func makeListingsSection() -> some View {
        Section(header: Text("NOOKAZON LISTINGS")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                if listingsViewModel.loading {
                    Text("Loading Listings...")
                        .foregroundColor(.secondary)
                }
                if !listingsViewModel.listings.isEmpty {
                    ForEach(listingsViewModel.listings.filter { $0.active && $0.selling }, content: makeListingCell)
                }
        }
    }
    
    var body: some View {
        List {
            informationSection
            if listingsViewModel.item.variants != nil {
                variantsSection
            }
            if !setItems.isEmpty {
                setSection
            }
            if listingsViewModel.item.materials != nil {
                materialsSection
            }
            makeListingsSection()
        }
        .onAppear(perform: {
            self.listingsViewModel.fetch(item: self.listingsViewModel.item)
        })
        .onDisappear {
            self.listingsViewModel.cancellable?.cancel()
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(listingsViewModel.item.name))
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemDetailView(viewModel: ItemsViewModel(categorie: .housewares),
                           listingsViewModel: ItemDetailViewModel(item: static_item))
                .environmentObject(Collection())
        }
    }
}
