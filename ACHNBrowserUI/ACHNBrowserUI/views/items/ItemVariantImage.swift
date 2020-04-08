//
//  ItemVariantImage.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 08/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct ItemVariantImage: View {
    @ObservedObject var imageLoader: ImageLoader
    @State var isImageLoaded = false
    
    var body: some View {
        ZStack(alignment: .center) {
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 30, height: 30)
                    .animation(.spring())
                    .onAppear{
                        self.isImageLoaded = true
                }
            } else {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

