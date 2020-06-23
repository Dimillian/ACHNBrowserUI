//
//  File.swift
//
//  Created by Otavio Cordeiro on 28.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

public struct Chore: Codable, Identifiable, Hashable, Equatable {
    public var id = UUID()
    public var title: String = ""
    public var description: String = ""
    public var isFinished: Bool = false

    public init(title: String = "", description: String = "", isFinished: Bool = false) {
        self.title = title
        self.description = description
        self.isFinished = isFinished
    }

    // MARK: - Equatable

    public static func == (lhs: Chore, rhs: Chore) -> Bool {
        lhs.id == rhs.id
    }
}
