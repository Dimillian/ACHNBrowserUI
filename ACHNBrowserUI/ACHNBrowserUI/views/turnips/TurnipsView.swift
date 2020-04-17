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
        cancellable = TurnipExchangeService
            .fetchIslands()
            .receive(on: RunLoop.main)
            .print()
            .sink(receiveCompletion: { _ in
                
            }) { [weak self] islands in
                self?.islands = islands
            }
    }
}

struct TurnipsView: View {
    @ObservedObject var viewModel = TurnipsViewModel()
    
    var body: some View {
        List {
            Section(header: Text("Chart")) {
                Text("Chart here")
            }
            Section(header: Text("Open Islands")) {
                if viewModel.islands == nil {
                    Text("Loading Islands...")
                }
                viewModel.islands.map {
                    ForEach($0) {
                        Text($0.name)
                    }
                }
            }
        }
        .onAppear(perform: viewModel.fetch)
    }
}
