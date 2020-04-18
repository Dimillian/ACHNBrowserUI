//
//  TurnipView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine

class TurnipsViewModel: ObservableObject {
    @Published var islands: [Island]?
    
    var cancellable: AnyCancellable?
    
    func fetch() {
        cancellable = TurnipExchangeService()
            .fetchIslands()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                
            }) { [weak self] islands in
                self?.islands = islands
            }
    }
}

struct TurnipCell: View {
    let island: Island
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(island.name)
                .font(.headline)
            Text(island.islandTime.description)
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
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                Text(island.hemisphere.rawValue.localizedCapitalized)
                    .font(.largeTitle)
                    .bold()
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
