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
    @State private var turnipsFormShown = false
    
    private let labels = ["Monday AM", "Monday PM", "Tuesday AM", "Tuesday PM", "Wednesday AM", "Wednesday PM",
                          "Thursday AM", "Thursday PM", "Friday AM", "Friday PM", "Saturday AM", "Saturday PM"]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Stalks market")) {
                    Button(action: {
                        self.turnipsFormShown = true
                    }) {
                        Text(TurnipFields.exist() ? "Edit your prices" : "Add your prices")
                            .foregroundColor(.blue)
                    }
                    if viewModel.predictions?.averagePrices != nil {
                        ForEach(viewModel.predictions!.averagePrices!, id: \.self) { value in
                            Text("Average \(self.labels[self.viewModel.predictions!.averagePrices!.firstIndex(of: value)!]): \(value)")
                        }
                    }
                }
                Section(header: Text("Exchange")) {
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
            }
            .navigationBarTitle("Turnips",
                                displayMode: .inline)
            .sheet(isPresented: $turnipsFormShown, content: { TurnipsFormView() })
        }
        .onAppear(perform: viewModel.fetch)
    }
}
