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
    public static let BASE_URL = URL(string: "https://acnhapi.com/v1/")!
    private static var cache: [String: Codable] = [:]
    
    public enum Endpoint {
        case villagers
        case villagerIcon(id: Int)
        case villagerImage(id: Int)
        case songs
        case songsImage(id: Int)
        case music(id: Int)
        
        public func path() -> String {
            switch self {
            case .villagers:
                return "villagers"
            case let .villagerIcon(id):
                return "icons/villagers/\(id)"
            case let .villagerImage(id):
                return "images/villagers/\(id)"
            case .songs:
                return "songs"
            case let .songsImage(id):
                return "images/songs/\(id)"
            case let .music(id):
                return "music/\(id)"
            }
        }
        
        public func url() -> URL {
            ACNHApiService.BASE_URL.appendingPathComponent(path())
        }
    }
    
    private static let decoder = JSONDecoder()
    
    public static func makeURL(endpoint: Endpoint) -> URL {
        let component = URLComponents(url: BASE_URL.appendingPathComponent(endpoint.path()),
                                      resolvingAgainstBaseURL: false)!
        return component.url!
    }
    
    public static func fetch<T: Codable>(endpoint: Endpoint) -> AnyPublisher<T ,APIError> {
        if let cached = Self.cache[endpoint.path()] as? T {
            return Just(cached)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
        let request = URLRequest(url: makeURL(endpoint: endpoint))
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ data, response in
                return try APIError.processResponse(data: data, response: response)
        }
        .decode(type: T.self, decoder: Self.decoder)
        .mapError{ APIError.parseError(reason: $0.localizedDescription) }
        .map({ result in
            Self.cache[endpoint.path()] = result
            return result
        })
        .eraseToAnyPublisher()
    }
}
