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
import JavaScriptCore
import Backend

class TurnipsViewModel: ObservableObject {
    @Published var islands: [Island]?
    @Published var predictions: TurnipPredictions?
    @Published var pendingNotifications = 0
        
    var cancellable: AnyCancellable?
        
    func refreshPrediction() {
        predictions = TurnipsPredictionService.shared.makeTurnipsPredictions()
    }
    
    func refreshPendingNotifications() {
        NotificationManager.shared.pendingNotifications { [weak self] requests in
            DispatchQueue.main.async {
                self?.pendingNotifications = requests.count
            }
        }
    }
    
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
