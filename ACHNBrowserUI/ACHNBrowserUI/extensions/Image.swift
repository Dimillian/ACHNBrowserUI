//
//  Image.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 09/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public extension Image {
    enum AppImageStyle {
        case barButton
    }
    
    func style(appStyle: AppImageStyle) -> some View {
        switch appStyle {
        case .barButton: return barButton()
        }
    }
}


extension Image {
    @ViewBuilder
    private func barButton() -> some View {
        self.resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
            .font(.system(size: 14, weight: .bold, design: .rounded))
    }
}
