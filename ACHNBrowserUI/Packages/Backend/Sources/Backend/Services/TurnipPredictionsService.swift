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
    public var turnipProhetUrl: URL? {
        guard let fields = fields, !fields.buyPrice.isEmpty else {
            return nil
        }
        var base = "https://turnipprophet.io/?prices=\(fields.buyPrice)."
        for field in fields.fields {
            base += field.isEmpty ? "." : "\(field)."
        }
        base += "&first=false&pattern=-1&achelper"
        return URL(string: base)
    }
    public var currentDate = Date()
    
    private var turnipsCancellable: AnyCancellable?
    private lazy var calculatorContext: JSContext? = {
        guard let url = Bundle.module.url(forResource: "turnips", withExtension: "js"),
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

        let averagePrices: [Int]? = (results?.toDictionary()["avgPattern"] as? [Int])?
            .enumerated()
            .map({ index, value in
                guard let enteredValue = Int(values.fields[index]) else {
                    return value
                }
                return enteredValue
        })

        let minMax: [[Int]]? = (results?.toDictionary()["minMaxPattern"] as? [[Int]])?
            .enumerated()
            .map({ index, value in
                guard let enteredValue = Int(values.fields[index]) else {
                    return value
                }
                return [enteredValue, enteredValue]
            })

        var averageProfits: [Int]?
        if let averagePrices = averagePrices,
            values.amount > 0,
            let buyPrice = Int(values.buyPrice) {
            averageProfits = []
            let investment = values.amount * buyPrice
            for avg in averagePrices {
                averageProfits?.append((avg * values.amount) - investment)
            }
        }
        
        return TurnipPredictions(minBuyPrice: results?.toDictionary()["minWeekValue"] as? Int,
                                 averagePrices: averagePrices,
                                 minMax: minMax,
                                 averageProfits: averageProfits,
                                 currentDate: currentDate)
    }
}
