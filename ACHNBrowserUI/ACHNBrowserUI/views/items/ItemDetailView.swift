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
    
    @State private var displayedVariant: Variant?
    @State private var selectedListing: URL?

    init(item: Item) {
        self.itemViewModel = ItemDetailViewModel(item: item)
    }
    
    var setItems: [Item] {
        guard let set = itemViewModel.item.set,
            let items = items.categories[itemViewModel.item.appCategory] else { return [] }
        return items.filter({ $0.set == set })
    }
    
    var similarItems: [Item] {
        guard let tag = itemViewModel.item.tag,
            let items = items.categories[itemViewModel.item.appCategory] else { return [] }
        return items.filter({ $0.tag == tag })
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
                if itemViewModel.item.itemImage == nil && displayedVariant == nil {
                    Image(itemViewModel.item.appCategory.iconName())
                        .resizable()
                        .frame(width: 150, height: 150)
                } else {
                    ItemImage(path: displayedVariant?.filename ?? itemViewModel.item.itemImage,
                              size: 150)
                }
                Spacer()
            }
            if itemViewModel.item.obtainedFrom != nil {
                Text(itemViewModel.item.obtainedFrom!)
                    .foregroundColor(.secondaryText)
            }
            if itemViewModel.item.isCritter {
                HStack(spacing: 8) {
                    if itemViewModel.item.rarity != nil {
                        HStack(spacing: 4) {
                            Text("Rarity:")
                            Text(itemViewModel.item.rarity!)
                                .foregroundColor(.secondaryText)
                        }
                    }
                    if itemViewModel.item.shadow != nil {
                        HStack(spacing: 4) {
                            Text("Shadow size:")
                            Text(itemViewModel.item.shadow!)
                                .foregroundColor(.secondaryText)
                        }
                    }
                }
            }
            if !itemViewModel.item.isCritter {
                Text("Customizable: \(itemViewModel.item.customize == true ? "Yes" : "no")")
                    .foregroundColor(.text)
            }
            HStack(spacing: 16) {
                if itemViewModel.item.sell != nil {
                    HStack(spacing: 2) {
                        Image("icon-bell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("\(itemViewModel.item.sell!)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.bell)
                        if itemViewModel.item.isCritter {
                            Text("Flick: ")
                                .foregroundColor(.text)
                                .padding(.leading, 8)
                            Text("\(Int(Float(itemViewModel.item.sell!) * 1.5))")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.bell)
                            
                        }
                    }
                }
                if itemViewModel.item.buy != nil {
                    HStack(spacing: 2) {
                        Image("icon-bells")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("\(itemViewModel.item.buy!)")
                            .foregroundColor(.bell)
                    }
                }
            }
        }
    }
    
    private var variantsSection: some View {
        Section(header: SectionHeaderView(text: "Variants")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(itemViewModel.item.variants!) { variant in
                            ItemImage(path: variant.filename,
                                      size: 75)
                                .onTapGesture {
                                    withAnimation {
                                        FeedbackGenerator.shared.triggerSelection()
                                        self.displayedVariant = variant
                                    }
                            }
                        }
                    }
                }
        }
    }
    
    private var materialsSection: some View {
        Section(header: SectionHeaderView(text: "Materials")) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(itemViewModel.item.materials!) { material in
                            VStack {
                                Image(material.iconName)
                                    .resizable()
                                    .frame(width: 50, height: 50)
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
    
    private func makeItemsSection(items: [Item], title: String) -> some View {
        Section(header: SectionHeaderView(text: title)) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(items) { item in
                        VStack(alignment: .center, spacing: 4) {
                            ItemImage(path: item.filename,
                                      size: 75)
                            Text(item.name)
                                .font(.caption)
                                .foregroundColor(.text)
                        }.onTapGesture {
                            FeedbackGenerator.shared.triggerSelection()
                            self.displayedVariant = nil
                            self.itemViewModel.item = item
                        }
                    }
                }
            }
        }
    }
    
    private var listingSection: some View {
        Section(header: SectionHeaderView(text: "Nookazon listings")) {
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
        Section(header: SectionHeaderView(text: "Seasonality")) {
                VStack(spacing: 8) {
                    if itemViewModel.item.formattedTimes() != nil {
                        HStack {
                            Spacer()
                            Image(systemName: "clock.fill").foregroundColor(.secondaryText)
                            Text("\(itemViewModel.item.formattedTimes()!)")
                                .foregroundColor(.secondaryText)
                                .font(.body)
                            Spacer()
                        }.padding(.top, 4)
                    }
                    if itemViewModel.item.activeMonths != nil {
                        HStack(alignment: .center) {
                            Spacer()
                            CalendarView(activeMonths: itemViewModel.item.activeMonths!)
                            Spacer()
                        }
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
                makeItemsSection(items: setItems, title: "Set items")
            }
            if !similarItems.isEmpty {
                makeItemsSection(items: similarItems, title: "Similar items")
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
        .navigationBarItems(trailing: LikeButtonView(item: self.itemViewModel.item))
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
