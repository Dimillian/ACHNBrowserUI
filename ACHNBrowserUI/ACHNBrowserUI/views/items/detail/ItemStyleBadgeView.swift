//
//  ItemStyleBadgeView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 26/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ItemStyleBadgeView: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text(NSLocalizedString(title, comment: "").capitalized)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1)
            Image(systemName: "chevron.right")
                .imageScale(.small)
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .background(RoundedRectangle(cornerRadius: 16)
        .foregroundColor(.acTabBarBackground))
    }
}

struct ItemStyleBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        ItemStyleBadgeView(title: "Elegant")
    }
}
