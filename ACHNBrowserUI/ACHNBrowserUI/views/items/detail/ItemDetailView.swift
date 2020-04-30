//
//  ItemDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemDetailView: View {
    @EnvironmentObject private var items: Items

    @ObservedObject private var itemViewModel: ItemDetailViewModel
    
    @State private var displayedVariant: Variant?
    @State private var selectedListing: URL?

    init(item: Item) {
        self.itemViewModel = ItemDetailViewModel(item: item)
    }
    
    var setItems: [Item] {
        guard let set = itemViewModel.item.set, set != "None",
            let items = items.categories[itemViewModel.item.appCategory] else { return [] }
        return items.filter({ $0.set == set })
    }
    
    var similarItems: [Item] {
        guard let tag = itemViewModel.item.tag, tag != "None",
            let items = items.categories[itemViewModel.item.appCategory] else { return [] }
        return items.filter({ $0.tag == tag })
    }
    
    var themeItems: [Item] {
        guard let theme = itemViewModel.item.themes?.filter({ $0 != "None" }).first,
            let items = items.categories[itemViewModel.item.appCategory] else { return [] }
        return items.filter({ $0.themes?.contains(theme) == true })
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
                    }.padding()
                }
                .listRowInsets(EdgeInsets())
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
                    }.padding()
                }
                .listRowInsets(EdgeInsets())
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
        
    var body: some View {
        List {
            ItemDetailInfoView(item: itemViewModel.item,
                               displayedVariant: $displayedVariant)
            if itemViewModel.item.variants != nil {
                variantsSection
            }
            if !setItems.isEmpty {
                ItemsCrosslineSectionView(title: "Set items",
                                          items: setItems,
                                          currentItem: $itemViewModel.item,
                                          selectedVariant: $displayedVariant)
            }
            if !similarItems.isEmpty {
                ItemsCrosslineSectionView(title: "Simillar items",
                                          items: similarItems,
                                          currentItem: $itemViewModel.item,
                                          selectedVariant: $displayedVariant)
            }
            if !themeItems.isEmpty {
                ItemsCrosslineSectionView(title: "Thematics",
                                          items: themeItems,
                                          currentItem: $itemViewModel.item,
                                          selectedVariant: $displayedVariant)
            }
            if itemViewModel.item.materials != nil {
                materialsSection
            }
            if itemViewModel.item.isCritter {
                ItemDetailSeasonSectionView(item: itemViewModel.item)
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
