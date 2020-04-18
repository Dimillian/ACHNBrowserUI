//
//  IslandDetailView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/18/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct IslandDetailView: View {
    var island: Island
    
    var body: some View {
        List {
            Section(header: Text("Island")) {
                TurnipCell(island: island)
                HStack {
                    Spacer()
                    Button("Join Island") {
                        
                    }
                    .accentColor(.grass)
                    Spacer()
                }
            }
            island.description.map { description in
                Section(header: Text("Description")) {
                    Text(description)
                }
            }
            Section(header: Text("Queue")) {
                Text("")
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(island.name)
    }
}
