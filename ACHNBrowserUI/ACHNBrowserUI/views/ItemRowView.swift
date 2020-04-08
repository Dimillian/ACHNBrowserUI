//
//  ItemRowView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemRowView: View {
    let item: Item
    
    func bellsView(title: String, price: Int) -> some View {
        HStack(spacing: 2) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.text)
            Text("\(price)")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.bell)
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            ItemImage(imageLoader: ImageLoader(path: item.image))
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.text)
                Text(item.obtainedFrom ?? "unknown source")
                    .font(.subheadline)
                    .foregroundColor(.text)
                HStack(spacing: 4) {
                    if item.buy != nil {
                        bellsView(title: "Buy for:", price: item.buy!)
                    }
                    if item.sell != nil {
                        bellsView(title: "Sell for:", price: item.sell!)
                    }
                }
            }
        }
    }
}

