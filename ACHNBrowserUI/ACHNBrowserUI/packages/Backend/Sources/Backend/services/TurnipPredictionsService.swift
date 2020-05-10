//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 30/04/2020.
//

import Foundation
import JavaScriptCore
import Combine

public class TurnipPredictionsService: ObservableObject {
    public static let shared = TurnipPredictionsService()
    
    @Published public var predictions: TurnipPredictions?
    public var fields: TurnipFields? {
        didSet {
            refresh()
        }
    }
    public var enableNotifications: Bool?
    
    private var turnipsCancellable: AnyCancellable?
    private lazy var calculatorContext: JSContext? = {
        guard let url = Bundle.main.url(forResource: "turnips", withExtension: "js"),
            let script = try? String(contentsOf: url) else {
                return nil
        }
        let context = JSContext()
        context?.evaluateScript(script)
        return context
    }()
    
    private init() {
        turnipsCancellable = $predictions
            .subscribe(on: RunLoop.main)
            .sink { predictions in
            if let predictions = predictions {
                if self.enableNotifications == true {
                    NotificationManager.shared.registerTurnipsPredictionNotification(prediction: predictions)
                } else if self.enableNotifications == false {
                    NotificationManager.shared.removePendingNotifications()
                }
            }
        }
        self.fields = TurnipFields.decode()
        self.refresh()
    }
    
    private func refresh() {
        if let fields = fields, !fields.buyPrice.isEmpty {
            self.predictions = calculate(values: fields)
        } else {
            self.predictions = nil
        }
    }
            
    private func calculate(values: TurnipFields) -> TurnipPredictions {
        let call = "calculate([\(values.buyPrice),\(values.fields.filter{ !$0.isEmpty }.joined(separator: ","))])"
        let results = calculatorContext?.evaluateScript(call)
        
        var averageProfits: [Int]?
        if let averagePrices = results?.toDictionary()["avgPattern"] as? [Int],
            values.amount > 0, let buyPrice = Int(values.buyPrice){
            averageProfits = []
            let investment = values.amount * buyPrice
            for avg in averagePrices {
                averageProfits?.append((avg * values.amount) - investment)
            }
        }
        
        return TurnipPredictions(minBuyPrice: results?.toDictionary()["minWeekValue"] as? Int,
                                 averagePrices: results?.toDictionary()["avgPattern"] as? [Int],
                                 minMax: results?.toDictionary()["minMaxPattern"] as? [[Int]],
                                 averageProfits: averageProfits)
    }
}
