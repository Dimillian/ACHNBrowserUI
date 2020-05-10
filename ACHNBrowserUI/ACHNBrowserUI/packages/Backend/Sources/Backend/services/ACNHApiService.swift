//
//  ACNHApiService.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

public struct ACNHApiService {
    public static let BASE_URL = URL(string: "http://acnhapi.com/")!
    
    public enum Endpoint {
        case villagers
        case villagerIcon(id: Int)
        case villagerImage(id: Int)
        
        public func path() -> String {
            switch self {
            case .villagers:
                return "villagers"
            case let .villagerIcon(id):
                return "icons/villagers/\(id)"
            case let .villagerImage(id):
                return "images/villagers/\(id)"
            }
        }
    }
    
    private static let decoder = JSONDecoder()
    
    public static func fetch<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T ,APIError> {
        let component = URLComponents(url: BASE_URL.appendingPathComponent(endpoint.path()),
                                      resolvingAgainstBaseURL: false)!
        let request = URLRequest(url: component.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ data, response in
                return try APIError.processResponse(data: data, response: response)
        }
        .decode(type: T.self, decoder: Self.decoder)
        .mapError{ APIError.parseError(reason: $0.localizedDescription) }
        .eraseToAnyPublisher()
    }
}
