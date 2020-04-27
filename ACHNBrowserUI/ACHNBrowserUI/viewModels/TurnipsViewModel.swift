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

class TurnipsViewModel: ObservableObject {
    @Published var islands: [Island]?
    @Published var predictions: TurnipPredictions?
    
    var cancellable: AnyCancellable?
    
    init() {
        if TurnipFields.exist() {
            let userTurnips = TurnipFields.decode()
            self.predictions = calculate(values: userTurnips)
        }
    }
    
    lazy var calculatorContext: JSContext? = {
        guard let url = Bundle.main.url(forResource: "turnips", withExtension: "js"),
            let script = try? String(contentsOf: url) else {
                return nil
        }
        let context = JSContext()
        context?.evaluateScript(script)
        return context
    }()
    
    func fetch() {
        cancellable = TurnipExchangeService.shared
            .fetchIslands()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in
                
            }) { [weak self] islands in
                self?.islands = islands
        }
    }
    
    func calculate(values: TurnipFields) -> TurnipPredictions {
        let call = "calculate([\(values.buyPrice),\(values.fields.filter{ !$0.isEmpty }.joined(separator: ","))])"
        let results = calculatorContext?.evaluateScript(call)
        return TurnipPredictions(minBuyPrice: results?.toDictionary()["minWeekValue"] as? Int,
                                 averagePrices: results?.toDictionary()["avgPattern"] as? [Int],
                                 minMax: results?.toDictionary()["minMaxPattern"] as? [[Int]])
    }
}
