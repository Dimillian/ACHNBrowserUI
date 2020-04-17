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
    struct SearchContainer: Decodable {
        var items: [SearchItem]
    }
    
    struct ListingContainer: Decodable {
        var listings: [Listing]
    }
    
    struct SearchItem: Decodable {
        var id: String
    }
    
    private static var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private static func searchItem(term: String) -> AnyPublisher<SearchItem, Error> {
        var components = URLComponents(string: "https://nookazon.com/api/items")
        components?.queryItems = [URLQueryItem(name: "search", value: term)]
        
        return URLSession.shared.dataTaskPublisher(for: components!.url!)
            .map { $0.data }
            .decode(type: SearchContainer.self, decoder: decoder)
            .compactMap { $0.items.first }
            .eraseToAnyPublisher()
    }
    
    static func fetchListings(item: Item) -> AnyPublisher<[Listing], Error> {
        searchItem(term: item.id)
        .receive(on: RunLoop.main)
        .flatMap {
            URLSession.shared.dataTaskPublisher(for: URL(string: "https://nookazon.com/api/listings?item=\($0.id)")!)
                .map { $0.data }
                .decode(type: ListingContainer.self, decoder: decoder)
                .map { $0.listings }
        }
        .eraseToAnyPublisher()
    }
}
