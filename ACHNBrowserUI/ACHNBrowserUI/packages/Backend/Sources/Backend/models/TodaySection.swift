//
//  File.swift
//  
//
//  Created by theunimpossible on 5/21/20.
//

import Foundation

public struct TodaySection: Codable, Hashable, Identifiable, Equatable {
    public let name: Name
    public var enabled: Bool
    public var id: Name { name }

    public init(name: Name, enabled: Bool) {
        self.name = name
        self.enabled = enabled
    }
    
    public static func == (lhs: TodaySection, rhs: TodaySection) -> Bool {
        lhs.id == rhs.id
    }
}

extension TodaySection {
    public enum Name: String, Codable {
        case events
        case specialCharacters
        case currentlyAvailable
        case collectionProgress
        case birthdays
        case turnips
        case subscribe
        case mysteryIsland
        case music
        case tasks
        case chores
        case nookazon
    }

    public static let defaultSectionList: [TodaySection] = [
        TodaySection(name: .events, enabled: true),
        TodaySection(name: .specialCharacters, enabled: true),
        TodaySection(name: .currentlyAvailable, enabled: true),
        TodaySection(name: .collectionProgress, enabled: true),
        TodaySection(name: .birthdays, enabled: true),
        TodaySection(name: .turnips, enabled: true),
        TodaySection(name: .tasks, enabled: true),
        TodaySection(name: .chores, enabled: true),
        TodaySection(name: .subscribe, enabled: true),
        TodaySection(name: .music, enabled: true),
        //TodaySection(name: .nameNookazon, enabled: true)
        TodaySection(name: .mysteryIsland, enabled: true),
    ]
}
