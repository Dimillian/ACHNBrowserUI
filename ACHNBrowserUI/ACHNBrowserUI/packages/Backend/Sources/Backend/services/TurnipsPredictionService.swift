//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 30/04/2020.
//

import Foundation
import JavaScriptCore

public class TurnipsPredictionService {
    public static let shared = TurnipsPredictionService()
    
    private lazy var calculatorContext: JSContext? = {
        guard let url = Bundle.main.url(forResource: "turnips", withExtension: "js"),
            let script = try? String(contentsOf: url) else {
                return nil
        }
        let context = JSContext()
        context?.evaluateScript(script)
        return context
    }()
    
    public func makeTurnipsPredictions() -> TurnipPredictions? {
        if TurnipFields.exist() {
            let userTurnips = TurnipFields.decode()
            if !userTurnips.buyPrice.isEmpty {
                return calculate(values: userTurnips)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    private func calculate(values: TurnipFields) -> TurnipPredictions {
        let call = "calculate([\(values.buyPrice),\(values.fields.filter{ !$0.isEmpty }.joined(separator: ","))])"
        let results = calculatorContext?.evaluateScript(call)
        return TurnipPredictions(minBuyPrice: results?.toDictionary()["minWeekValue"] as? Int,
                                 averagePrices: results?.toDictionary()["avgPattern"] as? [Int],
                                 minMax: results?.toDictionary()["minMaxPattern"] as? [[Int]])
    }
}
