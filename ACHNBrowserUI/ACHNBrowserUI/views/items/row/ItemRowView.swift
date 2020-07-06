//
//  ItemRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemRowView: View {
    enum DisplayMode {
        case compact, large, largeNoButton
    }
    
    let displayMode: DisplayMode
    let item: Item
    
    @State private var displayedVariant: Variant?
    
    private var imageSize: CGFloat {
        switch displayMode {
        case .compact:
            return 25
        case .large, .largeNoButton:
            return 100
        }
    }
    
    private var itemInfo: some View {
        Group {
            Text(item.localizedName.capitalized)
                .style(appStyle: .rowTitle)
            if item.appCategory == .seaCreatures {
                Text("Underwater")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.acSecondaryText)
            } else {
                Text(LocalizedStringKey(item.obtainedFrom ?? item.obtainedFromNew?.first ?? "unknown source"))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.acSecondaryText)
            }
        }
    }
    
    private var itemSubInfo: some View {
        HStack {
            if item.buy != nil {
                ItemBellsView(mode: .buy, price: item.buy!)
            }
            if item.sell != nil {
                ItemBellsView(mode: .buy, price: item.sell!)
            }
            Spacer(minLength: 0)
        }
    }
    
    private var itemVariants: some View {
        Group {
            if item.variations != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 2) {
                        item.variations.map { variations in
                            ForEach(variations) { variant in
                                ItemImage(path: variant.content.image,
                                          size: 25)
                                    .cornerRadius(4)
                                    .background(Rectangle()
                                        .cornerRadius(4)
                                        .foregroundColor(self.displayedVariant == variant ? Color.gray : Color.clear))
                                    .onTapGesture {
                                        FeedbackGenerator.shared.triggerSelection()
                                        self.displayedVariant = variant
                                }
                            }
                        }
                    }.frame(height: 30)
                }
            }
        }
    }
        
    var body: some View {
        HStack(spacing: 8) {
            if displayMode != .largeNoButton {
                LikeButtonView(item: item, variant: displayedVariant)
            }
            if item.finalImage == nil && displayedVariant == nil {
                Image(item.appCategory.iconName())
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
            } else {
                ItemImage(path: displayedVariant?.content.image ?? item.preferedVariantImage ?? item.finalImage,
                          size: imageSize)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                itemInfo
                if displayMode != .compact {
                    if (item.isCritter && item.formattedTimes() != nil) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.acSecondaryText)
                            Text(item.formattedTimes()!)
                                .foregroundColor(.acSecondaryText)
                                .fontWeight(.semibold)
                                .font(.caption)
                        }
                    }
                    itemSubInfo
                        .padding(.top, 4)
                    itemVariants
                }
            }
            Spacer(minLength: 0)
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VStack {
                List {
                    ItemRowView(displayMode: .large, item: static_item)
                        .environmentObject(UserCollection.shared)
                    ItemRowView(displayMode: .compact, item: static_item)
                        .environmentObject(UserCollection.shared)
                    ItemRowView(displayMode: .large, item: static_item)
                        .environmentObject(UserCollection.shared)
                }
                
                List {
                    ItemRowView(displayMode: .large, item: static_item)
                        .environmentObject(UserCollection.shared)
                    ItemRowView(displayMode: .compact, item: static_item)
                        .environmentObject(UserCollection.shared)
                    ItemRowView(displayMode: .large, item: static_item)
                        .environmentObject(UserCollection.shared)
                }
                .environment(\.colorScheme, .dark)
            }
        }
    }
}

