//
//  TurnipView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

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
                            TurnipIslandRow(island: island)
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
