//
//  DesignRowViewModel.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 24.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Backend

struct DesignRowViewModel {

    // MARK: - Properties

    private let design: Design

    public var title: String {
        design.title
    }

    public var description: String {
        design.description
    }

    public var code: String {
        formatted(code: design.code)
    }

    public var category: String {
        category(for: design.code)
    }

    // MARK: - Life cycle

    init(design: Design) {
        self.design = design
    }

    // MARK: - Private

    /// Formats the creator/item code to the format used by Nintendo.
    ///
    /// - Creator: MA-XXXX-XXXX-XXXX
    /// - Item: MO-XXXX-XXXX-XXXX
    ///
    /// - Parameter code: The code to be formatted.
    /// - Returns: Formatted string representing the given code.
    private func formatted(code: String) -> String {
        let codeFormat = "XX-XXXX-XXXX-XXXX"

        let filteredUnicodeScalars = code
            .uppercased()
            .unicodeScalars
            .filter(CharacterSet.alphanumerics.contains)

        let simplifiedCode = String(filteredUnicodeScalars)

        var result = ""
        var index = simplifiedCode.startIndex
        for character in codeFormat where index < simplifiedCode.endIndex {
            if character == "X" {
                result.append(simplifiedCode[index])
                index = codeFormat.index(after: index)
            } else {
                result.append(character)
            }
        }

        return result
    }

    /// Category based on code
    ///
    ///  - MA-XXXX-XXXX-XXXX -> Creator
    ///  - MO-XXXX-XXXX-XXXX -> Item
    ///
    /// - Parameter code: The code to be categorized.
    /// - Returns: The category based on the given code.
    private func category(for code: String) -> String {
        let prefix = String(code.uppercased().prefix(2))

        switch prefix {
        case "MA":
            return "Creator"
        default:
            return "Item"
        }
    }
}
