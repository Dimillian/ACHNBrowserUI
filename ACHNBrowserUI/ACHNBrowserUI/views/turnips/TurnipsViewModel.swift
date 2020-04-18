//
//  TurnipsViewModel.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/18/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class TurnipsViewModel: ObservableObject {
    @Published var islands: [Island]?
    
    var cancellable: AnyCancellable?
    
    func fetch() {
        cancellable = TurnipExchangeService.shared
            .fetchIslands()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                
            }) { [weak self] islands in
                self?.islands = islands
        }
    }
}
