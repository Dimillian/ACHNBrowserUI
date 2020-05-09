//
//  ProgressView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public struct ProgressView: View {
    public let progress: CGFloat
    public let trackColor: Color
    public let progressColor: Color
    
    public init(progress: CGFloat, trackColor: Color, progressColor: Color) {
        self.progress = progress
        self.trackColor = trackColor
        self.progressColor = progressColor
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { g in
                Capsule()
                    .foregroundColor(self.trackColor.opacity(0.2))
                    .frame(width: g.size.width)
                Capsule()
                    .foregroundColor(self.progressColor)
                    .frame(width: (g.size.width * self.progress) > 0 ? max(12, (g.size.width * self.progress)) : 0)
            }
        }
        .frame(height: 12)
        .background(Color.clear)
    }
}
