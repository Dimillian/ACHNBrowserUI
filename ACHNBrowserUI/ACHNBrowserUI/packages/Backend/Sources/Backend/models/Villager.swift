//
//  Villager.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

public struct Villager: Identifiable, Codable, Equatable {
    public let id: Int
    public let fileName: String?
    public let catchPhrase: String?
    public let name: [String: String]
    public let personality: String
    public let birthday: String?
    public var formattedBirthday: String? {
        guard let birthday = birthday else { return nil }
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("d/M")
        let day = formatter.date(from: birthday)!
        formatter.setLocalizedDateFormatFromTemplate("dd MMMM")
        return formatter.string(from: day)
    }
    
    public let gender: String
    public let species: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, personality, birthday, gender, species
        case fileName = "file-name"
        case catchPhrase = "catch-phrase"
    }
}
