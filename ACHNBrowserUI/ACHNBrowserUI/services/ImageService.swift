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

import UIImageColors
import SDWebImage

public class ImageService {
    private static let SERVICE_URL = "https://i.imgur.com/"
    public static let shared = ImageService()
        
    public func getImageColors(key: String, completionHandler: @escaping ((UIImageColors?) -> Void)) {
        let url = key.starts(with: "http") ? URL(string: key) : URL(string: "\(ImageService.SERVICE_URL)\(key).png")
        SDWebImageDownloader.shared.downloadImage(with: url!) { (image, _, _, _) in
            image?.getColors { colors in
                completionHandler(colors)
            }
        }
    }
}

