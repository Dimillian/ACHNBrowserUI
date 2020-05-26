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
        HStack(spacing: 2) {
            Text(NSLocalizedString(title, comment: "").capitalized)
                .font(.footnote)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(1)
        }
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(RoundedRectangle(cornerRadius: 16)
        .foregroundColor(.acTabBarBackground))
    }
}

struct ItemStyleBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        ItemStyleBadgeView(title: "Elegant")
    }
}
