//
//  Design.swift
//  
//  Created by Otavio Cordeiro on 24.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

public struct Design: Identifiable, Codable, Equatable {

    // MARK: - Properties

    public var id = UUID()
    public var title: String = ""
    public var code: String = ""
    public var description: String = ""

    public var hasValidCode: Bool {
        let validPrefixes: Set<String> = ["MA", "MO"]

        let simplifiedCode = code
            .uppercased()
            .unicodeScalars
            .filter(CharacterSet.alphanumerics.contains)

        guard
            simplifiedCode.count == 14,
            case let prefix = String(simplifiedCode.prefix(2)),
            validPrefixes.contains(prefix) else { return false }

        return true
    }

    // MARK: - Life cycle

    public init(title: String = "", code: String = "", description: String = "") {
        self.title = title
        self.code = code
        self.description = description
    }

    // MARK: - Equatable

    public static func == (lhs: Design, rhs: Design) -> Bool {
        lhs.id == rhs.id
    }
}
