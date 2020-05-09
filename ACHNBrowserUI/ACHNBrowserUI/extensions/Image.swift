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
    private func barButton() -> some View {
        self.imageScale(.medium)
            .font(.system(size: 16, weight: .bold, design: .rounded))
    }
}
