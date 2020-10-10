//
//  TurnipsUser.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 27/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

fileprivate let savePath = try! FileManager.default.url(for: .documentDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: true).appendingPathComponent("turnips")

public struct TurnipPredictions {
    public let minBuyPrice: Int?
    public let averagePrices: [Int]?
    public let minMax: [[Int]]?
    public let averageProfits: [Int]?
    public var currentDate: Date
    
    public var todayAverages: [Int]? {
        guard let averagePrices = averagePrices else {
            return nil
        }
        let today = Calendar.current.component(.weekday, from: Date())
        if today == 1 {
            return []
        }
        let base = (today * 2) - 4
        return [averagePrices[base], averagePrices[base + 1]]
    }
        
    public init(
        minBuyPrice: Int?,
        averagePrices: [Int]?,
        minMax: [[Int]]?,
        averageProfits: [Int]?,
        currentDate: Date
    ) {
        self.minBuyPrice = minBuyPrice
        self.averagePrices = averagePrices
        self.minMax = minMax
        self.averageProfits = averageProfits
        self.currentDate = currentDate
    }
}

public struct TurnipFields: Codable {
    public var buyPrice: String = ""
    public var fields = [String](repeating: "", count: 12)
    public var amount: Int = 0
    
    public static func exist() -> Bool {
        FileManager.default.fileExists(atPath: savePath.path)
        
    }
    
    public static func decode() -> TurnipFields {
        if let data = try? Data(contentsOf: savePath) {
            do {
                let decoder = JSONDecoder()
                return try decoder.decode(TurnipFields.self, from: data)
            } catch let error {
                print("Error while decoding turnips: \(error.localizedDescription)")
            }
        }
        return TurnipFields()
    }
    
    public func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            try data.write(to: savePath)
        } catch let error {
            print("Error while saving turnips: \(error.localizedDescription)")
        }
    }
    
    public mutating func clear() {
        buyPrice = ""
        amount = 0
        fields = [String](repeating: "", count: 12)
        save()
    }
}
