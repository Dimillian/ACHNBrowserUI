//
//  TurnipView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct TurnipsView: View {
    // MARK: - Vars
    private enum TurnipsDisplay: String, CaseIterable {
        case average, minMax
    }
    
    @ObservedObject var viewModel = TurnipsViewModel()
    @State private var turnipsFormShown = false
    @State private var turnipsDisplay: TurnipsDisplay = .average
    
    private let labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    // MARK: - Computed vars
    private var chunkedAveragePrices: [[Int]] {
        viewModel.predictions!.averagePrices!.chunked(into: 2)
    }
    
    private var chunkedMinMaxPrices: [[[Int]]] {
        viewModel.predictions!.minMax!.chunked(into: 2)
    }
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Stalks market")) {
                    Button(action: {
                        self.turnipsFormShown = true
                    }) {
                        Text(TurnipFields.exist() ? "Edit your in game prices" : "Add your in game prices")
                            .foregroundColor(.blue)
                    }
                }
                predictionsSection
                exchangeSection
            }
            .navigationBarTitle("Turnips",
                                displayMode: .inline)
            .sheet(isPresented: $turnipsFormShown, content: { TurnipsFormView(turnipsViewModel: self.viewModel) })
        }
        .onAppear(perform: viewModel.fetch)
        .onAppear(perform: viewModel.refreshPrediction)
    }
}

// MARK: - Views
extension TurnipsView {
    private var predictionsSection: some View {
        Section(header: Text(turnipsDisplay == .average ? "Average daily buy prices" : "Daily min max prices")) {
            if viewModel.predictions?.averagePrices != nil && viewModel.predictions?.minMax != nil {
                Picker(selection: $turnipsDisplay, label: Text("")) {
                    ForEach(TurnipsDisplay.allCases, id: \.self) { section in
                        Text(section.rawValue.capitalized)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                HStack {
                    Text("Day").fontWeight(.bold)
                    Spacer()
                    Text("AM").fontWeight(.bold)
                    Spacer()
                    Text("PM").fontWeight(.bold)
                }
                if turnipsDisplay == .average {
                    ForEach(chunkedAveragePrices, id: \.self) { day in
                        TurnipsAveragePriceRow(label: self.labels[self.chunkedAveragePrices.firstIndex(of: day)!],
                                               prices: day)
                    }
                } else if turnipsDisplay == .minMax {
                    ForEach(chunkedMinMaxPrices, id: \.self) { day in
                        TurnipsAveragePriceRow(label: self.labels[self.chunkedMinMaxPrices.firstIndex(of: day)!],
                                               minMaxPrices: day)
                    }
                }
            } else {
                Text("Add your in game turnips prices to see predictions")
            }
        }
    }
    
    private var exchangeSection: some View {
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
}
