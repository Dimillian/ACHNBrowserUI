//
//  ActivityController.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

#if !os(tvOS)
public struct ActivityControllerView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    public var activityItems: [Any]
    public var applicationActivities: [UIActivity]?
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityControllerView>) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        controller.completionWithItemsHandler = { _, _, _, _ in
            self.presentation.wrappedValue.dismiss()
        }
        return controller
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController,
                                       context: UIViewControllerRepresentableContext<ActivityControllerView>) {

    }
}
#endif
