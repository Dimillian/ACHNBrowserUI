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
    
    func safeOnDrag(data: @escaping () -> NSItemProvider) -> some View {
        onDrag(data)
    }
    
    func safeOnHover(action: @escaping (Bool) -> Void) -> some View {
        onHover(perform: action)
    }
    
    func safeHoverEffect(_ type: SafeHoverEffectType = .automatic ) -> some View {
        var hoverEffectType: HoverEffect
        
        switch(type) {
        case .lift:
            hoverEffectType = .lift
            
        case .highlight:
            hoverEffectType = .highlight
            
        case .automatic:
            fallthrough
            
        default:
            hoverEffectType = .automatic
        }
        
        return hoverEffect(hoverEffectType)
    }
    
    func safeHoverEffectBarItem(position: BarItemPosition) -> some View {
        let hoverPadding: CGFloat = 4
        
        // For leading bar items, we need to apply a negative offset equal to the overall padding to imitate Apple's styling in UIKit
        let offset = position == .leading ? -hoverPadding : hoverPadding
        
        return self
            .padding(hoverPadding)
            .safeHoverEffect()
            .offset(x:offset)
        
    }

    func eraseToAnyView() -> AnyView { AnyView(self) }
}

extension View {
    func propagate<K>(
        _ transform: @escaping (CGRect) -> K.Value,
        of source: Anchor<CGRect>.Source = .bounds,
        using key: K.Type
    ) -> some View where K: PreferenceKey {
        overlay(
            GeometryReader { proxy in
                Color.clear
                    .anchorPreference(key: key, value: source) { transform(proxy[$0]) }
            }
        )
    }

    func storeValue<K: PreferenceKey>(
        from key: K.Type = K.self,
        in storage: Binding<K.Value>
    ) -> some View where K.Value: Equatable {
        onPreferenceChange(key, perform: { storage.wrappedValue = $0 })
    }
}

extension UIView {
    public func asImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
}

// These enums can be removed and safeHoverEffect converted to just hoverEffect throughout if we no longer need to support < iPadOS 13.4
enum SafeHoverEffectType {
    case automatic
    case lift
    case highlight
}

// To simulate Apple's default UIKit hoverEffect padding on bar items, we need to specify if it's on the left or right and apply the right offset
enum BarItemPosition {
    case leading
    case trailing
}
