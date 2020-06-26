//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 26/06/2020.
//

import Foundation

extension Villager {
    public func formattedDate() -> Date {
        guard let birthday = birthday else { return Date() }
        let formatter = DateFormatter()
        
        formatter.dateFormat = "d/M"
        return formatter.date(from: birthday) ?? Date()
    }
    
    public func birthdayDay() -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dd")
        return formatter.string(from: formattedDate())
    }
    
    public func birthdayMonth() -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM")
        return formatter.string(from: formattedDate())
    }
    
}
