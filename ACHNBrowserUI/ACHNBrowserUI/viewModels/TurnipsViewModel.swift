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
    @Published var pendingNotifications = 0
    @Published var predictions: TurnipPredictions?
    @Published var averagesPrices: [[Int]]?
    @Published var averagesProfits: [[Int]]?
    @Published var minMaxPrices: [[[Int]]]?
        
    var turnipsCancellable: AnyCancellable?
    var exchangeCancellable: AnyCancellable?

    init() {
        turnipsCancellable = TurnipPredictionsService.shared.$predictions
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] predictions in
                self?.predictions = predictions
                if let predictions = predictions {
                    self?.refreshPrediction(predictions: predictions)
                    self?.refreshPendingNotifications()
                } else {
                    self?.averagesPrices = nil
                    self?.averagesProfits = nil
                    self?.minMaxPrices = nil
                }
            })
    }
    
    func refreshPrediction(predictions: TurnipPredictions) {
        averagesPrices = predictions.averagePrices?.chunked(into: 2)
        minMaxPrices = predictions.minMax?.chunked(into: 2)
        averagesProfits = predictions.averageProfits?.chunked(into: 2)
    }
    
    func refreshPendingNotifications() {
        NotificationManager.shared.pendingNotifications { [weak self] requests in
            DispatchQueue.main.async {
                self?.pendingNotifications = requests.count
            }
        }
    }
}
