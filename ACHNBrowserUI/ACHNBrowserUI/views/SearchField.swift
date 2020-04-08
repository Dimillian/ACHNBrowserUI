//
//  SearchField.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct SearchField: View {
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            TextField("Search an item", text: $searchText)
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.subheadline).foregroundColor(.red)
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
    }
}
