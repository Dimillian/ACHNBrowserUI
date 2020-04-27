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
    
    var cancellable: AnyCancellable?
    
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
    
    func calculate(values: [Int]) -> (avg: [Int]?, minValue: Int?, minMax: [[Int]]?) {
        let results = calculatorContext?.evaluateScript("calculate([\(values.map{ String($0) }.joined(separator: ","))])")
        return (avg: results?.toDictionary()["avgPattern"] as? [Int],
                minValue: results?.toDictionary()["minWeekValue"] as? Int,
                minMax: results?.toDictionary()["minMaxPattern"] as? [[Int]])
    }
}
