//
//  RoundedRectangleOnTop.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 30/01/2021.
//  Copyright © 2021 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct RoundedRectangleOnTop: Shape {
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Top left corner
        path.move(to: CGPoint(x: rect.minX, y: cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: rect.minY),
            control: CGPoint(x: rect.minX, y: rect.minY)
        )
        // Top right corner
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius),
            control: CGPoint(x: rect.maxX, y: rect.minY)
        )

        // Rest of the rectangle
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()

        return path
    }
}

#if DEBUG
struct RoundedRectangleOnTop_Previews: PreviewProvider {
    static var previews: some View {
        RoundedRectangleOnTop(cornerRadius: 20)
            .frame(width: 300, height: 100)
    }
}

#endif
