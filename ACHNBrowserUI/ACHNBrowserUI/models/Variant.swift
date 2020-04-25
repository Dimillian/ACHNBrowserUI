//
//  Variant.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 25/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import SwiftUI

struct Variant: Codable, Equatable, Identifiable {
    var id: String { filename }
    let filename: String
    let bodyTitle: String?
    let colors: [String]?
    let tag: String?
    let themes: [String]?
}
