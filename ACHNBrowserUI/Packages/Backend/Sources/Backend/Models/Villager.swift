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
    public let catchTranslations: [String: String]?
    public let name: [String: String]
    public let personality: String
    public let birthday: String?
    public var formattedBirthday: String? {
        guard let birthday = birthday else { return nil }
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M"
        let day = formatter.date(from: birthday)!
        formatter.setLocalizedDateFormatFromTemplate("dd MMMM")
        return formatter.string(from: day)
    }
    
    public let gender: String
    public let species: String
    
    public var localizedName: String { 
        guard let languageCode = Locale.current.languageCode,
            let key = self.name.keys.first(where: { $0.suffix(2) == languageCode }),
            let localizedName = self.name[key]
            else {
                return self.name["name-en"] ?? self.name["name-USen"] ?? ""
        }
        
        return localizedName
    }
    
    public var localizedCatchPhrase: String {
        guard let catchTranslations = catchTranslations,
            let languageCode = Locale.current.languageCode,
            let key = catchTranslations.keys.first(where: { $0.suffix(2) == languageCode }),
            let localizedPhrase = catchTranslations[key]
            else {
                return catchPhrase ?? ""
        }
        
        return localizedPhrase
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, personality, birthday, gender, species
        case fileName = "file-name"
        case catchPhrase = "catch-phrase"
        case catchTranslations = "catch-translations"
    }
}

public let static_villager = Villager(id: 354,
                                      fileName: "Pietro",
                                      catchPhrase: "honk honk",
                                      catchTranslations: [:],
                                      name: ["name-en": "Pietro"],
                                      personality: "Smug",
                                      birthday: "19/4",
                                      gender: "Male",
                                      species: "Sheep")
