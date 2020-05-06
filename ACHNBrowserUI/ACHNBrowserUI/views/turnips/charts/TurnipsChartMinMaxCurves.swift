//
//  TurnipsChartMinMaxCurves.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipsChartMinMaxCurves: Shape {
    let predictions: TurnipPredictions

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let minMax = predictions.minMax else {
            // Maybe we should just crash as it shouldn't happen
            return path
        }
        let (_, maxY, ratioY, ratioX) = predictions.minMax?.roundedMinMaxAndRatios(rect: rect) ?? (0, 0, 0, 0)

        let minPoints: [CGPoint] = minMax
            .compactMap { $0.first }
            .enumerated()
            .map({ offset, minValue in
                let x = ratioX * CGFloat(offset)
                let y = ratioY * (maxY - CGFloat(minValue))
                return CGPoint(x: x, y: y)
            })
        path.addHermiteCurvedLines(points: minPoints)

        let maxPoints: [CGPoint] = minMax
            .compactMap { $0.second }
            .enumerated()
            .map({ offset, maxValue in
                let x = ratioX * CGFloat(offset)
                let y = ratioY * (maxY - CGFloat(maxValue))
                return CGPoint(x: x, y: y)
            })
            .reversed()
        path.addLine(to: maxPoints.first ?? .zero)
        path.addHermiteCurvedLines(points: maxPoints)
        path.addLine(to: minPoints.first ?? .zero)

        return path
    }
}

private extension CGPoint {
    static func +(lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func -(lhs: Self, rhs: Self) -> Self {
        Self(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func /(lhs: Self, rhs: CGFloat) -> Self {
        Self(x: lhs.x/rhs, y: lhs.y/rhs)
    }

    static func *(lhs: Self, rhs: CGFloat) -> Self {
        Self(x: lhs.x * rhs, y: lhs.y * rhs)
    }
}

// Inspired from  https://github.com/FlexMonkey/SmoothScribble/blob/master/SmoothScribble/extensions/UIBezierPathExtension.swift
extension Path {
    mutating func addHermiteCurvedLines(points : [CGPoint], alpha : CGFloat = 1/3) {
        guard !points.isEmpty else { return }
        move(to: points.first ?? .zero)

        for (i, currentPoint) in points.enumerated() {
            if currentPoint == points.last { continue }

            let previousPoint = points[max(0, i - 1)]
            let nextPoint = points[min(i + 1, points.count - 1)]

            let previousDerivative = (nextPoint - previousPoint)/2
            let control1 = currentPoint + previousDerivative * alpha

            let furtherPoint = points[min(i + 2, points.count - 1)]

            let nextDerivative: CGPoint
            if i < points.count - 1 {
                nextDerivative = (furtherPoint - currentPoint)/2
            } else {
                nextDerivative = (nextPoint - currentPoint)/2
            }
            let control2 = nextPoint - nextDerivative * alpha

            self.addCurve(to: nextPoint, control1: control1, control2: control2)
        }
    }
}
