//
//  ItemDetailView.swift
//  ACHNBrowserUITV
//
//  Created by Thomas Ricouard on 30/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemDetailView: View {
    let item: Item
    
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
                if item.itemImage == nil{
                    Image(item.appCategory.iconName())
                        .resizable()
                        .frame(width: 150, height: 150)
                } else {
                    ItemImage(path: item.itemImage,
                              size: 150)
                }
                Spacer()
            }
            if item.obtainedFrom != nil || item.obtainedFromNew?.isEmpty == false {
                Text(item.obtainedFrom ?? item.obtainedFromNew?.first ?? "")
                    .foregroundColor(.acSecondaryText)
            }
            if item.isCritter {
                HStack(spacing: 8) {
                    if item.rarity != nil {
                        HStack(spacing: 4) {
                            Text("Rarity:")
                            Text(item.rarity!)
                                .foregroundColor(.acSecondaryText)
                        }
                    }
                    if item.shadow != nil {
                        HStack(spacing: 4) {
                            Text("Shadow size:")
                            Text(item.shadow!)
                                .foregroundColor(.acSecondaryText)
                        }
                    }
                }
            }
            if !item.isCritter {
                Text("Customizable: \(item.customize == true ? "Yes" : "no")")
                    .foregroundColor(.acText)
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
                            .foregroundColor(.acHeaderBackground)
                        if item.isCritter {
                            Text("Flick: ")
                                .foregroundColor(.acText)
                                .padding(.leading, 8)
                            Text("\(Int(Float(item.sell!) * 1.5))")
                                .font(.body)
                                .fontWeight(.semibold)
                                .foregroundColor(.acHeaderBackground)
                            
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
                            .foregroundColor(.acHeaderBackground)
                    }
                }
            }
        }
    }
}
