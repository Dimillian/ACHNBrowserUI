//
//  ImageService.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

public class ImageService {
    private static let SERVICE_URL = "https://i.imgur.com/"
    public static let shared = ImageService()
    
    public enum ImageError: Error {
        case decodingError
    }
    
    public func fetchImage(key: String) -> AnyPublisher<UIImage?, Never> {
        let url = key.starts(with: "http") ? URL(string: key) : URL(string: "\(ImageService.SERVICE_URL)\(key).png")
        return URLSession.shared.dataTaskPublisher(for: url!)
            .tryMap { (data, response) -> UIImage? in
                return UIImage(data: data)
        }.catch { error in
            return Just(nil)
        }
        .eraseToAnyPublisher()
    }
}

