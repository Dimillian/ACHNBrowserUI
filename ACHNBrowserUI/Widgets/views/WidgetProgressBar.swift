//
//  WidgetProgressBar.swift
//  WidgetsExtension
//
//  Created by Thomas Ricouard on 23/07/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI
import UI

struct WidgetProgressBar: View {
    public let progress: CGFloat
    private let height: CGFloat = 12
        
    public init(progress: CGFloat) {
        self.progress = progress
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { g in
                Capsule()
                    .foregroundColor(Color.gray.opacity(0.2))
                    .frame(width: g.size.width)
                Capsule()
                    .foregroundColor(.acBlueText)
                    .frame(width: g.size.width * self.progress > 0
                            ? max(self.height, (g.size.width * self.progress))
                            : 0)
            }
        }
        .frame(height: height)
        .background(Color.clear)
    }
}
