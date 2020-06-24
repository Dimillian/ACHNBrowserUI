//
//  Variant.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 25/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

public struct Variant: Codable, Equatable, Identifiable {
    public let id: Int
    public let content: Content
    
    public struct Content: Codable, Equatable {
        public let image: String
        public let colors: [String]?
    }
}
