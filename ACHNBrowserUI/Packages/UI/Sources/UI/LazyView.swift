//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 24/05/2020.
//
import SwiftUI

public struct LazyView<Content: View>: View {
    let build: () -> Content
    
    public init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    public var body: Content {
        build()
    }
}
