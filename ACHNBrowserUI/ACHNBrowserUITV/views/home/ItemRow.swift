//
//  ItemRow.swift
//  ACHNBrowserUITV
//
//  Created by Thomas Ricouard on 30/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct ItemRow: View {
    let item: Item
    @State private var focused = false
    
    var body: some View {
        VStack {
            ItemImage(path: item.finalImage, size: 150)
            Text(item.name)
        }
        .scaleEffect(focused ? 1.2 : 1.0)
        .animation(.interactiveSpring())
        .focusable(true) { isFocused in
            self.focused = isFocused
        }
    }
}
