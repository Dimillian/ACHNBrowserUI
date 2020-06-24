//
//  ProgressView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public struct ProgressBar: View {
    public let progress: CGFloat
    public let trackColor: Color
    public let progressColor: Color
    public let height: CGFloat
    
    @State private var appeared = false
    
    public init(progress: CGFloat, trackColor: Color, progressColor: Color, height: CGFloat) {
        self.progress = progress
        self.trackColor = trackColor
        self.progressColor = progressColor
        self.height = height
    }
    
    public var body: some View {
        ZStack {
            GeometryReader { g in
                Capsule()
                    .foregroundColor(self.trackColor.opacity(0.2))
                    .frame(width: g.size.width)
                Capsule()
                    .foregroundColor(self.progressColor)
                    .frame(width: (g.size.width * self.progress) > 0 && self.appeared
                        ? max(self.height, (g.size.width * self.progress))
                        : 0)
                    .animation(.spring())
            }
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.appeared = true
            }
        })
        .frame(height: height)
        .background(Color.clear)
    }
}
