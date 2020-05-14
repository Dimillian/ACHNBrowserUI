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
    
    func safeOnDrag(data: @escaping () -> NSItemProvider) -> AnyView {
        if #available(iOS 13.4, *) {
            return AnyView(onDrag(data))
        } else {
            return AnyView(self)
        }
    }
    
    func safeOnHover(action: @escaping (Bool) -> Void) -> AnyView {
        if #available(iOS 13.4, *) {
            return AnyView(onHover(perform: action))
        } else {
            return AnyView(self)
        }
    }
    
    func safeHoverEffect(_ type: SafeHoverEffectType = .automatic ) -> AnyView {
        if #available(iOS 13.4, *) {
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
            
            return AnyView(hoverEffect(hoverEffectType))
        } else {
            return AnyView(self)
        }
    }
    
    func safeHoverEffectBarItem(position: BarItemPosition) -> AnyView {
        let hoverPadding: CGFloat = 10
        
        // For leading bar items, we need to apply a negative offset equal to the overall padding to imitate Apple's styling in UIKit
        let offset = position == .leading ? -hoverPadding : hoverPadding
        
        return AnyView(self
            .padding(hoverPadding)
            .safeHoverEffect()
            .offset(x:offset)
        )
    }
}

extension View {
    func propagateHeight<K: PreferenceKey>(_ key: K.Type) -> some View where K.Value == CGFloat? {
        overlay(
            GeometryReader { proxy in
                Color.clear
                    .anchorPreference(key: key, value: .bounds, transform: { proxy[$0].height })
            }
        )
    }
    
    func onHeightPreferenceChange<K: PreferenceKey>(_ key: K.Type = K.self, storeValueIn storage: Binding<CGFloat?>) -> some View where K.Value == CGFloat? {
        onPreferenceChange(key, perform: { storage.wrappedValue = $0 })
    }

    func propagateWidth<K: PreferenceKey>(_ key: K.Type) -> some View where K.Value == CGFloat? {
        overlay(
            GeometryReader { proxy in
                Color.clear
                    .anchorPreference(key: key, value: .bounds, transform: { proxy[$0].width })
            }
        )
    }

    func onWidthPreferenceChange<K: PreferenceKey>(_ key: K.Type = K.self, storeValueIn storage: Binding<CGFloat?>) -> some View where K.Value == CGFloat? {
        onPreferenceChange(key, perform: { storage.wrappedValue = $0 })
    }

    func propagateSize<K: PreferenceKey>(_ key: K.Type = K.self, storeValueIn storage: Binding<CGSize?>) -> some View where K.Value == CGSize? {
        overlay(
            GeometryReader { proxy in
                Color.clear
                    .anchorPreference(key: key, value: .bounds, transform: { proxy[$0].size })
            }
        )
    }

    func onSizePreferenceChange<K: PreferenceKey>(_ key: K.Type = K.self, storeValueIn storage: Binding<CGSize?>) -> some View where K.Value == CGSize? {
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
