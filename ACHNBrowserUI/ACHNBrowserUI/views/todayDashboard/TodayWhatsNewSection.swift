//
//  TodayWhatsNewSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TodayWhatsNewSection: View {
    @Binding var showWhatsNew: Bool
    
    let version: String = "2020.2"
    
    var body: some View {
        Section(header: SectionHeaderView(text: "What's New", icon: "star.circle.fill")) {
            HStack {
                Text("See what's new in update \(version)")
                    .font(.system(.headline, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.acText)
                
                Spacer()
                
                Button(action: { self.showWhatsNew = false } ) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16, weight: .bold, design: .rounded))
                        .imageScale(.medium)
                }
                .accentColor(.acText)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 14, style: .continuous).foregroundColor(Color.acText.opacity(0.2)))
                
            }
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
            .animation(.default)
        }
    }
}

struct TodayWhatsNewSection_Previews: PreviewProvider {
    static var previews: some View {
        List {
            TodayWhatsNewSection(showWhatsNew: .constant(true))
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}
