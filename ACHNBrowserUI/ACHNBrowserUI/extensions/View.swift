//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 03/05/2020.
//

import Foundation
import SwiftUI
import UIKit

extension View {
    public func asImage() -> UIImage {
        let controller = UIHostingController(rootView: self)
        
        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)
        
        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()
        
        let image = controller.view.asImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
    public func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            rendererContext.cgContext.addPath(
            UIBezierPath(roundedRect: bounds, cornerRadius: 20).cgPath)
            rendererContext.cgContext.clip()
            layer.render(in: rendererContext.cgContext)
        }
    }
}
