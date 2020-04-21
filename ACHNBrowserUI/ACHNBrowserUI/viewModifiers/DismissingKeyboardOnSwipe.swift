//
//  DismissingKeyboardOnSwipe.swift
//  ACHNBrowserUI
//
//  Created by Renaud JENNY on 20/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

// See https://stackoverflow.com/questions/56491386/how-to-hide-keyboard-when-using-swiftui
struct DismissingKeyboardOnSwipe: ViewModifier {
    func body(content: Content) -> some View {
        #if os(macOS)
        return content
        #else
        return content.gesture(swipeGesture)
        #endif
    }

    private var swipeGesture: some Gesture {
        DragGesture(minimumDistance: 10, coordinateSpace: .global)
            .onChanged(endEditing)
    }

    private func endEditing(_ gesture: DragGesture.Value) {
        UIApplication.shared.connectedScenes
            .filter {$0.activationState == .foregroundActive}
            .map {$0 as? UIWindowScene}
            .compactMap({$0})
            .first?.windows
            .filter {$0.isKeyWindow}
            .first?.endEditing(true)
    }
}
