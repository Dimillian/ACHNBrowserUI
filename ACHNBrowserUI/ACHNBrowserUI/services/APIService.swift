//
//  APIService.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

struct APIService {
    static let BASE_URL = URL(string: API_URL)!
    
    private static let decoder = JSONDecoder()
    
    enum Endpoint: String, CaseIterable {
        case housewares, miscellaneous
        case wallMounted = "wall-mounted"
        case wallpaper, floors, rugs, photos, posters, fencing, tools
        case tops, bottoms, dresses, headwear, accessories, socks, shoes, bags
        case umbrellas, songs, recipes, fossils, construction, nookmiles, other
    }
    
    enum APIError: Error {
        case unknown
        case message(reason: String), parseError(reason: String), networkError(reason: String)
    }
    
    static func fetch<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T ,APIError> {
        let component = URLComponents(url: BASE_URL.appendingPathComponent(endpoint.rawValue),
                                      resolvingAgainstBaseURL: false)!
        let request = URLRequest(url: component.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.unknown
                }
                if (httpResponse.statusCode == 404) {
                    throw APIError.message(reason: "Resource not found");
                }
                return data
        }
        .decode(type: T.self, decoder: APIService.decoder)
        .mapError{ APIError.parseError(reason: $0.localizedDescription) }
        .eraseToAnyPublisher()
    }
}

