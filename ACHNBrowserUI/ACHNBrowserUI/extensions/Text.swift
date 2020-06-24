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
        case title, rowTitle, rowDescription, rowDetail
        case sectionHeader
    
    }
    
    func style(appStyle: AppTextStyle) -> Text {
        switch appStyle {
        case .title: return title()
        case .rowTitle: return rowTitle()
        case .rowDetail: return rowDetail()
        case .sectionHeader: return sectionHeader()
        case .rowDescription: return rowDescription()
        }
    }
}

extension Text {
    private func title() -> Text {
        self.font(.title)
            .fontWeight(.bold)
            .foregroundColor(.acText)
    }
    
    private func sectionHeader() -> Text {
        self.font(.system(.subheadline, design: .rounded))
            .fontWeight(.bold)
            .foregroundColor(.acHeaderText)
    }
    
    private func rowTitle() -> Text {
        self.font(.headline)
            .fontWeight(.bold)
            .foregroundColor(.acText)
    }
    
    private func rowDetail() -> Text {
        self.font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.acHeaderBackground)
    }
    
    private func rowDescription() -> Text {
        self.font(.subheadline)
            .foregroundColor(.acText)
    }
}
