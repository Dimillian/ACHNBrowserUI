//
//  NookazonService.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/16/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

struct NookazonService {
    struct ListingContainer: Decodable {
        var listings: [Listing]
    }

    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    static func fetchListings(item: Item) -> AnyPublisher<[Listing], Error> {
        var components = URLComponents(string: "https://acnh.ericlewis.dev/")
        components?.queryItems = [URLQueryItem(name: "search", value: item.id)]
        
        return URLSession.shared.dataTaskPublisher(for: components!.url!)
            .map { $0.data }
            .decode(type: ListingContainer.self, decoder: decoder)
            .map { $0.listings }
            .eraseToAnyPublisher()
    }
    
    static func recentListings() -> AnyPublisher<[Listing], Error> {
        URLSession.shared.dataTaskPublisher(for: URL(string: "https://nookazon.com/api/listings?size=6")!)
            .map { $0.data }
            .decode(type: ListingContainer.self, decoder: decoder)
            .map { $0.listings }
            .eraseToAnyPublisher()
    }
}
