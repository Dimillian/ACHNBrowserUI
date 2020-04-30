//
//  ItemDetailInfoView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 26/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemDetailInfoView: View {
    let item: Item
    @Binding var displayedVariant: Variant?
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(alignment: .center) {
                Image(item.appCategory.iconName())
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(item.appCategory.label())
                    .font(.callout)
                    .foregroundColor(.text)
            }
            HStack(alignment: .center) {
                Spacer()
                if item.itemImage == nil && displayedVariant == nil {
                    Image(item.appCategory.iconName())
                        .resizable()
                        .frame(width: 150, height: 150)
                } else {
                    ItemImage(path: displayedVariant?.filename ?? item.itemImage,
                              size: 150)
                }
                Spacer()
            }
            if item.obtainedFrom != nil {
                Text(item.obtainedFrom!)
                    .foregroundColor(.secondaryText)
            }
            if item.isCritter {
                HStack(spacing: 8) {
                    if item.rarity != nil {
                        HStack(spacing: 4) {
                            Text("Rarity:")
                            Text(item.rarity!)
                                .foregroundColor(.secondaryText)
                        }
                    }
                    if item.shadow != nil {
                        HStack(spacing: 4) {
                            Text("Shadow size:")
                            Text(item.shadow!)
                                .foregroundColor(.secondaryText)
                        }
                    }
                }
            }
            if !item.isCritter {
                Text("Customizable: \(item.customize == true ? "Yes" : "no")")
                    .foregroundColor(.text)
            }
            HStack(spacing: 16) {
                if item.sell != nil {
                    HStack(spacing: 2) {
                        Image("icon-bell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("\(item.sell!)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.bell)
                        if item.isCritter {
                            Text("Flick: ")
                                .foregroundColor(.text)
                                .padding(.leading, 8)
                            Text("\(Int(Float(item.sell!) * 1.5))")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.bell)
                            
                        }
                    }
                }
                if item.buy != nil {
                    HStack(spacing: 2) {
                        Image("icon-bells")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("\(item.buy!)")
                            .foregroundColor(.bell)
                    }
                }
            }
        }
    }
}

struct ItemDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailInfoView(item: static_item, displayedVariant: .constant(nil))
    }
}
