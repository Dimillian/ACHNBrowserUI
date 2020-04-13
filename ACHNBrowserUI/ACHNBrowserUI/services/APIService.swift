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
    // Will be available once the API is public
    // static let BASE_URL = URL(string: API_URL)!
    
    private static let decoder = JSONDecoder()
        
    enum APIError: Error {
        case unknown
        case message(reason: String), parseError(reason: String), networkError(reason: String)
    }
    
    static func fetch<T: Codable>(endpoint: Categories) -> AnyPublisher<T ,APIError> {
        let url = Bundle.main.url(forResource: endpoint.rawValue, withExtension: nil)!
        let data = try! Data(contentsOf: url)
        let component = URLComponents(url: URL(string: "https://localhost")!.appendingPathComponent(endpoint.rawValue),
                                      resolvingAgainstBaseURL: false)!
        let request = URLRequest(url: component.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .replaceError(with: (data: data, response: HTTPURLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: "utf8")))
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

