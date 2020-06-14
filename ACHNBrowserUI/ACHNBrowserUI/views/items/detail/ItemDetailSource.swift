//
//  ItemDetailSource.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import LinkPresentation

class ItemDetailSource: NSObject, UIActivityItemSource {
    let name: String
    let image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController,
                                itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        image
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        metadata.title = name
        metadata.imageProvider = NSItemProvider(object: image)
        
        return metadata
    }
}
