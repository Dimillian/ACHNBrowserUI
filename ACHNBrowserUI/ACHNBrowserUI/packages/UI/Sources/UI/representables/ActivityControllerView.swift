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
    
    public let activityItems: [Any]
    public let applicationActivities: [UIActivity]?
    
    public init(activityItems: [Any], applicationActivities: [UIActivity]?) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityControllerView>) -> UIActivityViewController {
        return UIActivityViewController(activityItems: activityItems,
                                        applicationActivities: applicationActivities)
    }
    
    public func updateUIViewController(_ uiViewController: UIActivityViewController,
                                       context: UIViewControllerRepresentableContext<ActivityControllerView>) {
        
    }
}
#endif
