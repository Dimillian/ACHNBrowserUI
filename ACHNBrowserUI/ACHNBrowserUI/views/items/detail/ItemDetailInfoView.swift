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
                    .foregroundColor(.acText)
            }
            HStack(alignment: .center) {
                Spacer()
                if item.finalImage == nil && displayedVariant == nil {
                    Image(item.appCategory.iconName())
                        .resizable()
                        .frame(width: 150, height: 150)
                } else {
                    ItemImage(path: displayedVariant?.filename ?? item.finalImage,
                              size: 150)
                }
                Spacer()
            }
            if item.obtainedFrom != nil || item.obtainedFromNew?.isEmpty == false {
                Text(item.obtainedFrom ?? item.obtainedFromNew?.first ?? "")
                    .foregroundColor(.acSecondaryText)
                    .fontWeight(.semibold)
            }
            item.sourceNotes.map{
                Text($0)
                    .foregroundColor(.acSecondaryText)
                    .font(.footnote)
            }
            if item.isCritter {
                HStack(spacing: 8) {
                    item.rarity.map { rarity in
                        HStack(spacing: 4) {
                            Text("Rarity:")
                            Text(rarity)
                                .foregroundColor(.acSecondaryText)
                        }
                    }
                    item.shadow.map { shadow in
                        HStack(spacing: 4) {
                            Text("Shadow size:")
                            Text(shadow)
                                .foregroundColor(.acSecondaryText)
                        }
                    }
                }
            }
            if !item.isCritter {
                Text("Customizable: \(item.customize == true ? NSLocalizedString("Yes", comment: "") : NSLocalizedString("No", comment: ""))")
                    .foregroundColor(.acText)
            }
            HStack(spacing: 16) {
                item.sell.map { sell in
                    HStack(spacing: 2) {
                        Image("icon-bell")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("\(sell)")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(.acHeaderBackground)
                        if item.isCritter {
                            Text("Flick:")
                                .foregroundColor(.acText)
                                .padding(.leading, 8)
                            Text("\(Int(Float(sell) * 1.5))")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.acHeaderBackground)
                            
                        }
                    }
                }
                item.buy.map { buy in
                    HStack(spacing: 2) {
                        Image("icon-bells")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25, height: 25)
                        Text("\(buy)")
                            .foregroundColor(.acHeaderBackground)
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
