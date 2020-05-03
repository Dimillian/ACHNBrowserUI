//
//  Text.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 03/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

extension Text {
    func title() -> Text {
        self.font(.title)
            .fontWeight(.bold)
            .foregroundColor(.text)
    }
}
