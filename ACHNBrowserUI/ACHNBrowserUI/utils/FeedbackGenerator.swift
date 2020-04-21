//
//  FeedbackGenerator.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 21/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import UIKit

class FeedbackGenerator {
    static let shared = FeedbackGenerator()
    
    private let notificationGenerator = UINotificationFeedbackGenerator()
    
    func triggerNotification(type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.prepare()
        notificationGenerator.notificationOccurred(type)
    }
}
