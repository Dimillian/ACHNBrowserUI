//
//  DodoCodeDetailView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 15/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct DodoCodeDetailView: View {    
    let code: DodoCode
        
    var body: some View {
        List {
            Section(header: SectionHeaderView(text: code.islandName,
                                              icon: "sun.haze.fill")) {
                DodoCodeRow(code: code, showButtons: true).listRowBackground(Color.acSecondaryBackground)
            }
            CommentsSection(model: code)
        }
        .animation(.interactiveSpring())
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Comments")
    }
}

struct DodoCodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DodoCodeDetailView(code: static_dodoCode)
    }
}
