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
    @EnvironmentObject private var collection: UserCollection
    
    enum DisplayMode {
        case small, big
    }
    
    let displayMode: DisplayMode
    let item: Item
    
    @State private var displayedVariant: Variant?
    
    private var imageSize: CGFloat {
        switch displayMode {
        case .small:
            return 25
        case .big:
            return 100
        }
    }

    private func bellsView(icon: String, price: Int) -> some View {
        HStack(spacing: 2) {
            Image(icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
            Text("\(price)")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.bell)
                .lineLimit(1)
        }
    }
    
    private var itemInfo: some View {
        Group {
            Text(item.name)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.text)
            Text(item.obtainedFrom ?? "unknown source")
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondaryText)
        }
    }
    
    private var itemSubInfo: some View {
        HStack {
            if (item.isCritter && item.formattedTimes() != nil) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.secondaryText)
                    Text(item.formattedTimes()!)
                        .foregroundColor(.secondaryText)
                        .fontWeight(.semibold)
                        .font(.caption)
                }
            }
            if item.buy != nil {
                bellsView(icon: "icon-bells",
                          price: item.buy!)
            }
            if item.sell != nil {
                bellsView(icon: "icon-bell",
                          price: item.sell!)
            }
            Spacer()
        }
    }
    
    private var itemVariants: some View {
        Group {
            if item.variants != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 2) {
                        ForEach(item.variants!) { variant in
                            ItemImage(path: variant.filename,
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
                    }.frame(height: 30)
                }
            }
        }
    }
        
    var body: some View {
        HStack(spacing: 8) {
            LikeButtonView(item: item)
            if item.itemImage == nil && displayedVariant == nil {
                Image(item.appCategory.iconName())
                    .resizable()
                    .frame(width: imageSize, height: imageSize)
            } else {
                ItemImage(path: displayedVariant?.filename ?? item.itemImage,
                          size: imageSize)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                itemInfo
                if displayMode == .big {
                    itemSubInfo
                    itemVariants
                }
            }
            
            Spacer()
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ItemRowView(displayMode: .big, item: static_item)
                    .environmentObject(UserCollection())
                ItemRowView(displayMode: .small, item: static_item)
                    .environmentObject(UserCollection())
                ItemRowView(displayMode: .big, item: static_item)
                    .environmentObject(UserCollection())
            }
        }
    }
}

