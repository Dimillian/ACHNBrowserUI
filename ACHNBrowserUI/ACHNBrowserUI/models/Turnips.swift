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

struct TurnipPredictions: Codable {
    let minBuyPrice: Int?
    let averagePrices: [Int]?
    let minMax: [[Int]]?
}

struct TurnipFields: Codable {
    var buyPrice: String = ""
    var fields = [String](repeating: "", count: 12)
    
    static func exist() -> Bool {
        FileManager.default.fileExists(atPath: savePath.path)
        
    }
    static func decode() -> TurnipFields {
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
    
    func save() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            try data.write(to: savePath)
        } catch let error {
            print("Error while saving turnips: \(error.localizedDescription)")
        }
    }
}
