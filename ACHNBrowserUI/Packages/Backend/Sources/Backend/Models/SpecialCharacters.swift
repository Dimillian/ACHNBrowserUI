//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 19/05/2020.
//

import Foundation
import SwiftUI

public enum SpecialCharacters: String, CaseIterable {
    case kk, daisy, cj, flick, kicks, saharah, gulliver, label, leif, redd, wisp, celeste
    
    public static func forDate(_ currentDate: Date) -> [SpecialCharacters] {
        let day = Calendar.current.component(.weekday, from: currentDate)
        let hour = Calendar.current.component(.hour, from: currentDate)
        if day == 1 {
            return [.daisy]
        } else if day == 7 {
            return [.kk]
        } else {
            var standard = Self.standard()
            if hour >= 18 {
                standard.insert(.celeste, at: 0)
            }
            if hour >= 20 {
                standard.insert(.wisp, at: 0)
            }
            return standard
        }
    }
    
    public func localizedName() -> LocalizedStringKey {
        switch self {
        case .kk:
            return LocalizedStringKey("K.K Slider")
        case .daisy:
            return LocalizedStringKey("Daisy Mae")
        case .cj:
            return LocalizedStringKey("C.J")
        case .flick:
            return LocalizedStringKey("Flick")
        case .kicks:
            return LocalizedStringKey("Kicks")
        case .saharah:
            return LocalizedStringKey("Saharah")
        case .gulliver:
            return LocalizedStringKey("Gulliver")
        case .label:
            return LocalizedStringKey("Label")
        case .leif:
            return LocalizedStringKey("Leif")
        case .redd:
            return LocalizedStringKey("Redd")
        case .wisp:
            return LocalizedStringKey("Wisp")
        case .celeste:
            return LocalizedStringKey("Celeste")
        }
    }
    
    private static func standard() -> [SpecialCharacters] {
        return [.saharah, .leif, .kicks, .redd, .label, .gulliver, .cj, .flick]
    }
    
    public func timeOfTheDay() -> LocalizedStringKey {
        switch self {
        case .kk, .cj, .flick, .kicks, .gulliver, .label, .redd, .leif, .saharah:
            return LocalizedStringKey("All day")
        case .celeste:
            return LocalizedStringKey("From 6pm to 5am")
        case .wisp:
            return LocalizedStringKey("From 8pm to 5am")
        case .daisy:
            return LocalizedStringKey("From 5am to 12pm")
        }
    }
}
