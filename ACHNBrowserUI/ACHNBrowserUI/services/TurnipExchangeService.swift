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
    private static let baseURL = URL(string: "https://api.turnip.exchange")!
    private static let session = URLSession.shared
    
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    /// Get a list of all the islands
    /// GET request
    static func fetchIslands() -> AnyPublisher<[Island], Error> {
        session.dataTaskPublisher(for: baseURL.appendingPathComponent("islands"))
            .map { $0.data }
            .decode(type: IslandContainer.self, decoder: decoder)
            .map { $0.islands }
            .eraseToAnyPublisher()
    }
    
    /// Host a new island
    /// Creates a listing on turnip.exchange
    /// PUT request
    static func host(dodoCode: String,
                     commerce: Island.Commerce,
                     turnipPrice: Int,
                     fruit: Island.Fruit,
                     hemisphere: Island.Hemisphere,
                     islandTime: Date = Date(),
                     private: Bool = false) -> AnyPublisher<CreateResponse, Error> {
        var request = URLRequest(url: baseURL.appendingPathComponent("island/create/\(dodoCode)"))
        
        request.httpMethod = "PUT"
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: CreateResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    /// Get the islands current queue
    /// GET request
    static func fetchQueue(turnipCode: String) -> AnyPublisher<Island, Error> {
        session.dataTaskPublisher(for: baseURL.appendingPathComponent("island/queue/\(turnipCode)"))
            .map { $0.data }
            .decode(type: Island.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    /// Delete existing island
    /// DELETE request
    static func delete(turnipCode: String) -> AnyPublisher<ResultContainer, Error> {
        var request = URLRequest(url: baseURL.appendingPathComponent("island/\(turnipCode)"))
        
        request.httpMethod = "DELETE"
        
        return session.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: ResultContainer.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
    
    /// Request to join an island
    static func join(turnipCode: String) -> AnyPublisher<Island, Error> {
        session.dataTaskPublisher(for: baseURL.appendingPathComponent("island/\(turnipCode)"))
            .map { $0.data }
            .decode(type: Island.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

struct ResultContainer: Decodable {
    let success: Bool
    let message: String
}

struct IslandContainer: Decodable {
    let success: Bool
    let message: String
    let islands: [Island]
}

struct CreateResponse: Decodable {
    let success: Bool
    let dodoCode: String
    let gateStatus: Int
    let name: String
    let playerId: Double
    let ownerName: String
    let id: String
    let turnipCode: String
}

struct QueueContainer: Decodable {
    let success: Bool
    let onIsland: Int
    let visitors: [Visitor]
    let total: Int
    let visitorCount: Int
}

struct Visitor: Decodable {
    let name: String
    let id: Int
    let addedTimestamp: String
    let place: Int
    let time: Int
}
