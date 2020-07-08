//
//  ItemGridItemView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 06/07/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemGridItemView: View {
    let item: Item
    var body: some View {
        ZStack(alignment: .topLeading) {
            LikeButtonView(item: item, variant: nil)
                .padding(.top, 8)
                .padding(.leading, 8)
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    Spacer()
                    ItemImage(path: item.finalImage,
                              size: 50)
                    Text(item.localizedName)
                        .foregroundColor(.acText)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .padding(.horizontal, 8)
                    Text(LocalizedStringKey(item.obtainedFrom ?? item.obtainedFromNew?.first ?? "unknown source"))
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.acSecondaryText)
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                    Spacer()
                }
                Spacer()
            }
        }
        .background(Color.acSecondaryBackground)
        .cornerRadius(8)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 150)
    }
}

struct ItemGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemGridItemView(item: static_item)
    }
}
