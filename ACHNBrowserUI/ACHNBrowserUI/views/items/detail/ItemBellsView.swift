//
//  ItemBellsView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 26/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemBellsView: View {
    enum Mode {
        case buy, sell, cj, flick
        
        func iconName() -> String {
            switch self {
            case .sell: return "icon-bell"
            case .buy: return "icon-bells"
            case .cj: return "cj"
            case .flick: return "flick"
            }
        }
    }
    
    let mode: Mode
    let price: Int
    
    var body: some View {
        HStack(spacing: 2) {
            Image(mode.iconName())
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
            Text("\(price)")
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.acHeaderBackground)
                .lineLimit(0)
        }
        .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 8))
        .background(RoundedRectangle(cornerRadius: 16)
        .foregroundColor(.catalogBar))
    }
}

struct ItemBellsView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            ItemBellsView(mode: .sell, price: 100)
            ItemBellsView(mode: .buy, price: 100)
            ItemBellsView(mode: .cj, price: 100)
            ItemBellsView(mode: .flick, price: 100)
        }
    }
}
