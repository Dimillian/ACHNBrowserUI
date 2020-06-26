//
//  SectionHeaderView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 21/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct SectionHeaderView: View {
    let text: LocalizedStringKey
    var icon: String?
    
    init(text: LocalizedStringKey, icon: String? = nil) {
        self.text = text
        self.icon = icon
    }
    
    init(text: String, icon: String? = nil) {
        self.init(text: LocalizedStringKey(text), icon: icon)
    }
    
    var body: some View {
        HStack(spacing: 6) {
            if icon != nil {
                Image(systemName: icon!)
                    .imageScale(.medium)
                    .font(.system(.subheadline, design: .rounded))
                    .foregroundColor(.acHeaderText)
                    .rotationEffect(.degrees(-3))
            }
            
            Text(text)
                .style(appStyle: .sectionHeader)
                .lineLimit(1)
                .textCase(nil)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 14)
        .background(Color.acHeaderBackground)
        .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .padding(.leading, -9)
        .padding(.bottom, -10)
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(text: "Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
