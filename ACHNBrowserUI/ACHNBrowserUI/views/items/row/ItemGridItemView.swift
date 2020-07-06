//
//  ItemGridItemView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 06/07/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct ItemGridItemView: View {
    let item: Item
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.acText)
                .frame(width: 50, height: 50)
                .padding(.top, 8)
            Text(item.localizedName)
                .foregroundColor(.acText)
                .font(.footnote)
                .lineLimit(2)
                .frame(width: 90)
                .padding(.horizontal, 8)
            Text(LocalizedStringKey(item.obtainedFrom ?? item.obtainedFromNew?.first ?? "unknown source"))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.acSecondaryText)
                .padding()
        }
        .background(Color.acSecondaryBackground)
        .cornerRadius(8)
    }
}

struct ItemGridItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemGridItemView(item: static_item)
    }
}
