//
//  ImageService.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import UIImageColors
import SDWebImage

public class ImageService {
    public static let SERVICE_URL = "https://i.imgur.com/"
        
    class func computeUrl(key: String) -> URL {
        key.starts(with: "http") || key.starts(with: "https") ? URL(string: key)! : URL(string: "\(Self.SERVICE_URL)\(key).png")!
    }
    
    class func getImageColors(key: String, completionHandler: @escaping ((UIImageColors?) -> Void)) {
        SDWebImageDownloader.shared.downloadImage(with: computeUrl(key: key)) { (image, _, _, _) in
            image?.getColors { colors in
                completionHandler(colors)
            }
        }
    }
}

