//
//  IslandDetailViewModel.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/18/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class IslandDetailViewModel: ObservableObject {
    @Published var container: TurnipExchangeService.QueueContainer?
    
    var cancellable: AnyCancellable?
    
    func fetch(turnipCode: String) {
        cancellable = TurnipExchangeService.shared
            .fetchQueue(turnipCode: turnipCode)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                
            }) { [weak self] container in
                self?.container = container
        }
    }
}
