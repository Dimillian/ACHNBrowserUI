//
//  ItemsAPI.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

public struct ItemsAPI {
    private static let decoder = JSONDecoder()
    private static let apiQueue = DispatchQueue(label: "nookazon_api",
                                                qos: .userInitiated,
                                                attributes: .concurrent)
            
    public static func fetch<T: Codable>(endpoint: Category) -> AnyPublisher<T ,APIError> {
        Self.fetchFile(name: endpoint.rawValue)
    }
    
    public static func fetchVillagerHouse() -> AnyPublisher<[VillagerHouse], APIError> {
        Self.fetchFile(name: "villagersHouse")
    }
    
    public static func fetchVillagerLikes() -> AnyPublisher<[String: VillagerLike], APIError> {
        Self.fetchFile(name: "villagersLikes")
    }
    
    public static func fetchFile<T: Codable>(name: String) -> AnyPublisher<T ,APIError> {
        Result(catching: {
            guard let url = Bundle.module.url(forResource: name, withExtension: nil) else {
                throw APIError.message(reason: "Error while loading local ressource")
            }
            return try Data(contentsOf: url)
        })
            .publisher
            .decode(type: T.self, decoder: Self.decoder)
            .mapError{ APIError.parseError(reason: $0.localizedDescription) }
            .subscribe(on: Self.apiQueue)
            .eraseToAnyPublisher()
    }
}

