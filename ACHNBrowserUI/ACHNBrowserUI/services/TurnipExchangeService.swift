//
//  TurnipExchangeService.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/17/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

struct TurnipExchangeService {
    struct IslandContainer: Decodable {
        let success: Bool
        let message: String
        let islands: [Island]
    }
    
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    static func fetchIslands() -> AnyPublisher<[Island], Error> {
        URLSession.shared.dataTaskPublisher(for: URL(string: "https://api.turnip.exchange/islands")!)
            .map { $0.data }
            .decode(type: IslandContainer.self, decoder: decoder)
            .map { $0.islands }
            .eraseToAnyPublisher()
    }
}
