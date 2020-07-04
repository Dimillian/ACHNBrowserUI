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
    let recipe: Item?
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
                    ItemImage(path: displayedVariant?.content.image ?? item.finalImage,
                              size: 150)
                }
                Spacer()
            }
            if item.furnitureImage != nil && item.iconImage != nil {
                HStack(alignment: .center, spacing: 12) {
                    Spacer()
                    ItemImage(path: item.furnitureImage!,
                              size: 100)
                    ItemImage(path: item.iconImage!,
                              size: 100)
                    Spacer()
                }
            }
            if item.obtainedFrom != nil || item.obtainedFromNew?.isEmpty == false {
                Text(LocalizedStringKey(item.obtainedFrom ?? item.obtainedFromNew?.first ?? ""))
                    .foregroundColor(.acSecondaryText)
                    .fontWeight(.semibold)
            }
            item.sourceNotes.map{
                Text(LocalizedStringKey($0))
                    .foregroundColor(.acSecondaryText)
                    .font(.footnote)
            }
            if item.isCritter {
                VStack(spacing: 4) {
                    item.shadow.map { shadow in
                        HStack(spacing: 4) {
                            Text("Shadow size:")
                            Text(LocalizedStringKey(shadow))
                                .foregroundColor(.acSecondaryText)
                        }
                    }
                    item.movementSpeed.map { speed in
                        HStack(spacing: 4) {
                            Text("Movement speed:")
                            Text(LocalizedStringKey(speed))
                                .foregroundColor(.acSecondaryText)
                        }
                    }
                }
            }
            if !item.isCritter {
                Text("Customizable: \(item.customize == true || recipe?.customize == true ? NSLocalizedString("Yes", comment: "") : NSLocalizedString("No", comment: ""))")
                    .foregroundColor(.acText)
            }
            
            HStack(alignment: .center, spacing: 16) {
                item.buy.map { buy in
                    ItemBellsView(mode: .buy, price: buy)
                }
                item.sell.map { sell in
                    Group {
                        ItemBellsView(mode: .sell, price: sell)
                        if item.isCritter {
                            if item.appCategory == .bugs {
                                ItemBellsView(mode: .flick,
                                              price: Int(Float(sell) * 1.5))
                            } else {
                                ItemBellsView(mode: .cj,
                                              price: Int(Float(sell) * 1.5))
                            }
                        }
                    }
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 4)
        }
    }
}

struct ItemDetailInfoView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ItemDetailInfoView(item: static_item,
                               recipe: nil,
                               displayedVariant: .constant(nil))
        }
    }
}
