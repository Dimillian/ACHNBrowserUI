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
    var placeholder: LocalizedStringKey = "Search..."

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .imageScale(.large)
            TextField(placeholder, text: $searchText)
                .foregroundColor(Color.acText)
                .font(.headline)
                .accentColor(.acHeaderBackground)
                .textCase(nil)
            if !searchText.isEmpty {
                Button(action: {
                    self.searchText = ""
                }) {
                    Image(systemName: "xmark.circle")
                        .font(.headline)
                        .foregroundColor(.red)
                        .imageScale(.large)
                }.buttonStyle(BorderlessButtonStyle())
            }
        }
        .padding(8)
        .background(Color.acSecondaryBackground)
        .mask(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .padding(2)
        .listRowBackground(Color.acBackground)
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                Section(header:
                    SearchField(searchText: .constant("Editing"),
                                placeholder: "test"))
                {
                    SearchField(searchText: .constant(""),
                                placeholder: "Placeholder")
                    SearchField(searchText: .constant("Editing"),
                                placeholder: "test")
                    Text("An item")
                                                            
                }
                
            }.listStyle(InsetGroupedListStyle())
        }
    }
}
