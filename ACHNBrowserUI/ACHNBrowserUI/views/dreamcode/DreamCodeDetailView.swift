//
//  DreamCodeDetailView.swift
//  ACHNBrowserUI
//
//  Created by Jan van Heesch on 02.08.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct DreamCodeDetailView: View {
    let code: DreamCode
        
    var body: some View {
        List {
            Section(header: SectionHeaderView(text: code.islandName,
                                              icon: "moon.zzz")) {
                DreamCodeRow(code: code, showButtons: true)
            }
            CommentsSection(model: code)
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Comments")
    }
}

struct DreamCodeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DreamCodeDetailView(code: static_dreamCode)
    }
}

