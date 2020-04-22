//
//  ItemImage.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemImage : View {
    let path: String?
    let size: CGFloat
    
    var body: some View {
        WebImage(url: path != nil ? ImageService.computeUrl(key: path!) : nil)
            .resizable()
            .renderingMode(.original)
            .indicator(.activity) 
            .animation(.easeInOut(duration: 0.1))
            .transition(.fade)
            .aspectRatio(contentMode: .fit)
            .frame(width: size, height: size)
            .animation(.spring())
    }
}
