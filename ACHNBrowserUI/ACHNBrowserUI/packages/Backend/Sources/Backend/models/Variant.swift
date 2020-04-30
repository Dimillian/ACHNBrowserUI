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
    public var id: String { filename }
    public let filename: String
    public let bodyTitle: String?
    public let colors: [String]?
    public let tag: String?
    public let themes: [String]?
}
