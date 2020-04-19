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
    
    @State var pattern: UInt32 = 2
    @State var seed: UInt32 = 0
    @State var prices: [(UInt32, UInt32)] = []
    
    let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"]
    
    func calculate() {
        prices = TurnipPricesWrapper().calculate(withPattern: NSNumber(value: pattern), seed: NSNumber(value: seed)).map {
            ($0.morningPrice.uint32Value, $0.afternoonPrice.uint32Value)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Calculation")) {
                    ForEach(0..<prices.count, id: \.self) {
                        Text("\(self.days[$0]): \(self.prices[$0].0) - \(self.prices[$0].1)")
                    }
                    Stepper(onIncrement: {
                        if self.pattern == 3 {
                            return
                        }
                        
                        self.pattern += 1
                        self.calculate()
                    }, onDecrement: {
                        if self.pattern == 0 {
                            return
                        }
                        
                        self.pattern -= 1
                        self.calculate()
                    }) {
                        Text("Pattern: \(pattern)")
                    }
                    Stepper(onIncrement: {
                        self.seed += 1
                        self.calculate()
                    }, onDecrement: {
                        if self.seed == 0 {
                            return
                        }
                        
                        self.seed -= 1
                        self.calculate()
                    }) {
                        Text("Seed: \(seed)")
                    }
                }
                Section(header: Text("Open Islands")) {
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
            }
            .navigationBarTitle("Turnips",
                                displayMode: .inline)
        }
        .onAppear(perform: viewModel.fetch)
        .onAppear(perform: calculate)
    }
}
