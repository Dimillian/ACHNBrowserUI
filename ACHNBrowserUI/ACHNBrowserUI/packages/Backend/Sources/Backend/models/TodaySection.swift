//
//  File.swift
//  
//
//  Created by theunimpossible on 5/21/20.
//

import Foundation

public struct TodaySection: Codable, Hashable, Equatable {
    public static let nameEvents = "events"
    public static let nameSpecialCharacters = "specialCharacters"
    public static let nameCurrentlyAvailable = "currentlyAvailable"
    public static let nameCollectionProgress = "collectionProgress"
    public static let nameBirthdays = "birthdays"
    public static let nameTurnips = "turnips"
    public static let nameSubscribe = "subscribe"
    public static let nameMysteryIsland = "mysteryIsland"
    
    public static let defaultSectionList: [TodaySection] = [
        TodaySection(name: Self.nameEvents, enabled: true),
        TodaySection(name: Self.nameSpecialCharacters, enabled: true),
        TodaySection(name: Self.nameCurrentlyAvailable, enabled: true),
        TodaySection(name: Self.nameCollectionProgress, enabled: true),
        TodaySection(name: Self.nameBirthdays, enabled: true),
        TodaySection(name: Self.nameTurnips, enabled: true),
        TodaySection(name: Self.nameSubscribe, enabled: true),
        TodaySection(name: Self.nameMysteryIsland, enabled: true),
    ]
    
    public static func == (lhs: TodaySection, rhs: TodaySection) -> Bool {
        return lhs.name == rhs.name
    }

    public let name: String
    public var enabled: Bool
}
