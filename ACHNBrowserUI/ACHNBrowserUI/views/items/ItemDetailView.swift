//
//  ItemDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    @EnvironmentObject private var items: Items

    @ObservedObject private var itemViewModel: ItemDetailViewModel
    
    @State private var displayedVariant: String?
    @State private var selectedListing: URL?

    init(item: Item) {
        self.itemViewModel = ItemDetailViewModel(item: item)
    }
    
    var setItems: [Item] {
        guard let set = itemViewModel.item.set,
            let items = items.categories[itemViewModel.item.appCategory] else { return [] }
        return items.filter({ $0.set == set })
    }
    
    private var informationSection: some View {
        VStack(spacing: 4) {
            HStack(alignment: .center) {
                Image(itemViewModel.item.appCategory.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(itemViewModel.item.appCategory.label())
                    .font(.callout)
                    .foregroundColor(.text)
            }
            HStack(alignment: .center) {
                Spacer()
                if itemViewModel.item.image == nil && displayedVariant == nil {
                    Image(itemViewModel.item.appCategory.iconName())
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
                            self.selectedListing = URL.nookazon(listing: listing)
                        }) {
                            ListingRow(listing: listing)
                        }
                    })
                }
        }
    }
    
    private var seasonalityView: some View {
        Section(header: Text("Seasonality")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                VStack(spacing: 8) {
                    if itemViewModel.item.formattedStartTime() != nil &&
                        itemViewModel.item.formattedEndTime() != nil {
                        HStack {
                            Spacer()
                            Image(systemName: "clock.fill").foregroundColor(.secondaryText)
                            Text("\(itemViewModel.item.formattedStartTime()!) - \(itemViewModel.item.formattedEndTime()!)h")
                                .foregroundColor(.secondaryText)
                                .font(.body)
                            Spacer()
                        }.padding(.top, 4)
                    } else if itemViewModel.item.startTimeAsString() != nil {
                        HStack {
                            Spacer()
                            Text(itemViewModel.item.startTimeAsString()!)
                                .foregroundColor(.secondaryText)
                                .font(.body)
                            Spacer()
                        }
                    }
                    HStack(alignment: .center) {
                        Spacer()
                        CalendarView(selectedMonths: itemViewModel.item.activeMonths())
                        Spacer()
                    }
                }
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
            if itemViewModel.item.isCritter {
                seasonalityView
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
        .navigationBarItems(trailing: StarButtonView(item: self.itemViewModel.item))
        .navigationBarTitle(Text(itemViewModel.item.name))
        .sheet(item: $selectedListing) {
            SafariView(url: $0)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemDetailView(item: static_item)
                .environmentObject(UserCollection())
        }
    }
}
