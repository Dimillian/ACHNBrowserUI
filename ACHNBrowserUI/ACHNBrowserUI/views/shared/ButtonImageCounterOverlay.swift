//
//  ButtonImageOverlay.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 13/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ButtonImageCounterOverlay: View {
    let symbol: String
    let foregroundColor: Color
    let counter: Int?
    
    var body: some View {
        Image(systemName: symbol)
            .foregroundColor(foregroundColor)
            .font(.footnote)
            .padding(.vertical, 7)
            .padding(.horizontal, 8)
            .background(Color.acBackground)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(counterView, alignment: .topTrailing)
    }
    
    private var counterView: some View {
        Group {
            if counter != nil {
                Text("\(counter!)")
                    .font(.footnote)
                    .foregroundColor(.acText)
                    .background(Circle()
                                    .scale(2)
                                    .foregroundColor(Color.acBackground))
                    .opacity(counter! > 0 ? 1 : 0)
                    .animation(.linear)
                    .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: -6))
            } else {
                EmptyView()
            }
        }
    }
}
