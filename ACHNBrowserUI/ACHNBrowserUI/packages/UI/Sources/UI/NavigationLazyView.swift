//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 09/05/2020.
//

import Foundation
import SwiftUI

public struct NavigationLazyView<Content: View>: View {
    public let build: () -> Content
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    public var body: Content {
        build()
    }
}
