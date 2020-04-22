//
//  SectionHeaderView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 21/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct SectionHeaderView: View {
    let text: String
    
    var body: some View {
        Group {
            HStack {
                Text(text).font(.headline)
            }
            .padding(8)
            .background(Color.dialogueReverse)
            .cornerRadius(20)
        }.padding(.leading, -8)
    }
}

struct SectionHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SectionHeaderView(text: "Preview")
    }
}
