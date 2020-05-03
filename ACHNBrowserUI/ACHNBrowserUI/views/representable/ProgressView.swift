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
    
    public var body: some View {
        ZStack {
            GeometryReader { proxy in
                RoundedRectangle(cornerRadius: 4)
                    .fill(self.trackColor)
                RoundedRectangle(cornerRadius: 4)
                    .fill(self.progressColor)
                    .frame(width: proxy.size.width * self.progress)
            }
        }
        .frame(height: 8)
        .background(Color.clear)
    }
}
