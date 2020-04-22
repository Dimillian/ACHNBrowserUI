//
//  ItemRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemRowView: View {
    @EnvironmentObject private var collection: UserCollection
    
    let item: Item
    
    @State private var displayedVariant: String?

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
            if (item.formattedStartTime() != nil && item.formattedEndTime() != nil) ||
                item.startTimeAsString() != nil {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .foregroundColor(.secondaryText)
                    if item.formattedStartTime() != nil && item.formattedEndTime() != nil {
                        Text("\(item.formattedStartTime()!)-\(item.formattedEndTime()!)h")
                            .foregroundColor(.secondaryText)
                            .font(.caption)
                            .fontWeight(.semibold)
                    } else if item.startTimeAsString() != nil {
                        Text(item.startTimeAsString()!)
                            .foregroundColor(.secondaryText)
                            .fontWeight(.semibold)
                            .font(.caption)
                    }
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
                        ForEach(item.variants!, id: \.self) { variant in
                            ItemImage(path: variant,
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
            if item.image == nil && displayedVariant == nil {
                Image(item.appCategory.iconName())
                    .resizable()
                    .frame(width: 100, height: 100)
            } else {
                ItemImage(path: displayedVariant ?? item.image,
                          size: 100)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                itemInfo
                itemSubInfo
                itemVariants
            }
            
            Spacer()
        }
    }
}

struct ItemRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                ItemRowView(item: static_item)
                    .environmentObject(UserCollection())
                ItemRowView(item: static_item)
                    .environmentObject(UserCollection())
                ItemRowView(item: static_item)
                    .environmentObject(UserCollection())
            }
        }
    }
}

