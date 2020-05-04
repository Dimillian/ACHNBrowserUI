//
//  Text.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public extension Text {
    enum AppTextStyle {
        case title, rowTitle
        case sectionHeader
    }
    
    func style(appStyle: AppTextStyle) -> Text {
        switch appStyle {
        case .title: return title()
        case .rowTitle: return rowTitle()
        case .sectionHeader: return sectionHeader()
        }
    }
}

extension Text {
    private func title() -> Text {
        self.font(.title)
            .fontWeight(.bold)
            .foregroundColor(.text)
    }
    
    private func sectionHeader() -> Text {
        self.font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(Color.dialogue)
    }
    
    private func rowTitle() -> Text {
        self.font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.text)
    }
}
