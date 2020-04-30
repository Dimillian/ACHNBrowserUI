//
//  NookPlazaAPIService.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine

public struct NookPlazaAPIService {
    // Will be available once the API is public
    // static let BASE_URL = URL(string: API_URL)!
    
    private static let decoder = JSONDecoder()
            
    // Here we fake the API so we use localshost and replace any response with a local response coming from bundle files.
    public static func fetch<T: Codable>(endpoint: Category) -> AnyPublisher<T ,APIError> {
        let url = Bundle.main.url(forResource: endpoint.rawValue, withExtension: nil)!
        let data = try! Data(contentsOf: url)
        let component = URLComponents(url: URL(string: "https://localhost")!.appendingPathComponent(endpoint.rawValue),
                                      resolvingAgainstBaseURL: false)!
        let request = URLRequest(url: component.url!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .replaceError(with: (data: data, response: HTTPURLResponse(url: url, mimeType: nil, expectedContentLength: 0, textEncodingName: "utf8")))
            .tryMap{ data, response in
                return try APIError.processResponse(data: data, response: response)
        }
        .decode(type: T.self, decoder: NookPlazaAPIService.decoder)
        .mapError{
            APIError.parseError(reason: $0.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
}

