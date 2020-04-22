//
//  EventsDescription.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 21/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import ACNHEvents

extension Event {
    func title() -> String {
        switch self {
        case .bunnyDay:
            return "Bunny Day"
        case .bugOff:
            return "Bugg tourney"
        case .cherryBlossumSeason:
            return "Blossom trees"
        case .earthDay:
            return "Earth Day"
        case .fishingTourney:
            return "Fishing tourney"
        case .mayDay:
            return "May Day"
        case .museumDay:
            return "Museum Day"
        case .natureDay:
            return "Nature Day"
        case .newYearsDay:
            return "New Year Day"
        case .newYearsEve:
            return "New Years Eve"
        case .weddingSeason:
            return "Wedding season"
        }
    }
    
    static func nextEvent() -> (Date, Event?) {
        let aDay: TimeInterval = 24*60*60
        let today = Date()
        let endDate = today.addingTimeInterval(aDay * 365)
        var nextDate = today.addingTimeInterval(aDay)
        var event: Event? = nil
        
        while nextDate.compare(endDate) == .orderedAscending
        {
            event = nextDate.events(for: .north).first
            if event != nil {
                break
            }
            nextDate = nextDate.addingTimeInterval(aDay)
        }
        return (nextDate, event)
    }
}
