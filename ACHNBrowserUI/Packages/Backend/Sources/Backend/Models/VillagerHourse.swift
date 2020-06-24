//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 09/05/2020.
//

import Foundation

public struct VillagerHouse: Identifiable, Codable {
    public let id: String
    public let wallaper: Item?
    public let floor: Item?
    public let music: Item?
    public let items: [Item]?
    
    public struct Item: Identifiable, Codable {
        public let id: Int
        public let name: String
    }
}
