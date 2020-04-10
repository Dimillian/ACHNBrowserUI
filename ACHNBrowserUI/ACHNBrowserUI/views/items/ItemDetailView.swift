//
//  ItemDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemDetailView: View {
    @State var item: Item
    @ObservedObject var viewModel: ItemsViewModel
    @State private var displayedVariant: String?
    
    private var informationSection: some View {
        Section(header: Text("INFORMATION")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                HStack(alignment: .center) {
                    Spacer()
                    ItemImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: displayedVariant ?? item.image),
                              size: 150)
                    Spacer()
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
                        ForEach(item.variants!, id: \.self) { variant in
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
    
    private var setSection: some View {
        Section(header: Text("SET ITEMS")
            .font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.items.filter({ $0.set == item.set} )) { item in
                            VStack(alignment: .center, spacing: 4) {
                                ItemImage(imageLoader: ImageLoaderCache.shared.loaderFor(path: item.image),
                                          size: 75)
                                Text(item.name)
                                    .font(.caption)
                                    .foregroundColor(.text)
                            }.onTapGesture {
                                self.displayedVariant = nil
                                self.item = item
                            }
                        }
                    }
                }
        }
    }
    
    var body: some View {
        List {
            informationSection
            if item.variants != nil {
                variantsSection
            }
            
            if item.set != nil {
                setSection
            }
        }
        .onAppear(perform: {
            self.viewModel.fetch()
        })
        .listStyle(GroupedListStyle())
        .navigationBarTitle(Text(item.name))
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ItemDetailView(item: static_item,
                           viewModel: ItemsViewModel(categorie: .housewares))
                .environmentObject(Collection())
        }
    }
}
