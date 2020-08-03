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
        case villagerVisits
        case dodoCode
        case news
        case dreamCode
    }

    public static let defaultSectionList: [TodaySection] = [
        TodaySection(name: .events, enabled: true),
        TodaySection(name: .news, enabled: true),
        TodaySection(name: .specialCharacters, enabled: true),
        TodaySection(name: .currentlyAvailable, enabled: true),
        TodaySection(name: .collectionProgress, enabled: true),
        TodaySection(name: .birthdays, enabled: true),
        TodaySection(name: .dodoCode, enabled: true),
        TodaySection(name: .dreamCode, enabled: true),
        TodaySection(name: .turnips, enabled: true),
        TodaySection(name: .tasks, enabled: true),
        TodaySection(name: .chores, enabled: true),
        TodaySection(name: .subscribe, enabled: true),
        TodaySection(name: .music, enabled: true),
        TodaySection(name: .mysteryIsland, enabled: true),
        TodaySection(name: .villagerVisits, enabled: true),
    ]
}


extension TodaySection {
    public var sectionName: String {
        switch name {
        case .events: return "Events"
        case .specialCharacters: return "Possible visitors"
        case .currentlyAvailable: return "Currently Available"
        case .collectionProgress: return "Collection Progress"
        case .birthdays: return "Today's Birthdays"
        case .turnips: return "Turnips"
        case .subscribe: return "AC Helper+"
        case .mysteryIsland: return "Mystery Islands"
        case .music: return "Music player"
        case .tasks: return "Today's Tasks"
        case .chores: return "Chores"
        case .villagerVisits: return "Villager visits"
        case .dodoCode: return "Latest Dodo code"
        case .news: return "News"
        case .dreamCode: return "Latest Dream Code"
        }
    }
    
    public var iconName: String {
        switch name {
        case .events: return "flag.fill"
        case .specialCharacters: return "clock"
        case .currentlyAvailable: return "calendar"
        case .collectionProgress: return "chart.pie.fill"
        case .birthdays: return "gift.fill"
        case .turnips: return "dollarsign.circle.fill"
        case .subscribe: return "suit.heart.fill"
        case .mysteryIsland: return "sun.haze.fill"
        case .music: return "music.note"
        case .tasks: return "checkmark.seal.fill"
        case .chores: return "checkmark.seal.fill"
        case .villagerVisits: return "person.crop.circle.fill.badge.checkmark"
        case .dodoCode: return "airplane"
        case .news: return "exclamationmark.bubble.fill"
        case .dreamCode: return "zzz"
        }
    }
}
