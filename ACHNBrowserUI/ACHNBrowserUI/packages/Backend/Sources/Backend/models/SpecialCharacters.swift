//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 19/05/2020.
//

import Foundation

public enum SpecialCharacters: String, CaseIterable {
    case kk, daisy, cj, flick, kicks, saharah, gulliver, label, leif, redd, wisp, celeste
    
    public static func now() -> [SpecialCharacters] {
        let day = Calendar.current.component(.weekday, from: Date())
        let hour = Calendar.current.component(.hour, from: Date())
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
    
    private static func standard() -> [SpecialCharacters] {
        return [.saharah, .leif, .kicks, .redd, .label, .gulliver, .cj, .flick]
    }
}
