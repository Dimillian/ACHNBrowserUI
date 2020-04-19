//
//  TurnipView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TurnipCell: View {
    let island: Island
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(island.name)
                .foregroundColor(.text)
                .font(.headline)
            Text(island.islandTime.description)
                .foregroundColor(.secondaryText)
                .font(.subheadline)
            HStack {
                Spacer()
                island.fruit.image
                Spacer()
                Divider()
                Spacer()
                Text("\(island.turnipPrice)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.text)
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                Text(island.hemisphere.rawValue.localizedCapitalized)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.text)
                Spacer()
            }
        }
    }
}

struct TurnipsView: View {
    @ObservedObject var viewModel = TurnipsViewModel()
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.islands == nil {
                    Text("Loading Islands...")
                        .foregroundColor(.secondary)
                }
                viewModel.islands.map {
                    ForEach($0) { island in
                        NavigationLink(destination: IslandDetailView(island: island)) {
                            TurnipCell(island: island)
                        }
                    }
                }
            }
            .navigationBarTitle("Turnips",
                                displayMode: .inline)
        }
        .onAppear(perform: viewModel.fetch)
    }
}
