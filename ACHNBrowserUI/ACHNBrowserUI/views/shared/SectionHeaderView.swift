//
//  SectionHeaderView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 21/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct SectionHeaderView: View {
    @State private var curved: Bool = false
    
    let text: String
    
    var body: some View {
        
        Text(text)
            .font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color.dialogue)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(Color.bell)
            .mask(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .padding(.leading, -10)
            .padding(.bottom, -12)
            .rotationEffect(.degrees(self.curved ? -0.5 : 0))
            .shadow(color: Color.black.opacity(0.15), radius: 2, x: 0, y: 1)
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(text: "Preview")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
