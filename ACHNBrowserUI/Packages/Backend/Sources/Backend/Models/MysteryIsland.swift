//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 17/05/2020.
//

import Foundation

public struct MysteryIsland: Codable, Identifiable {
    public let id: Int
    public let max_visit: Int?
    public let chance: Int
    public let flowers: String
    public let trees: String
    public let name: String
    public let description: String
    public let rocks: Int
    public let rocks_type: String
    public let insects: String
    public let fish: String
    
    public var image: String {
        "mapthumb\(id)"
    }
    
    private static var islands: [MysteryIsland]?
    
    public static func loadMysteryIslands() -> [MysteryIsland]? {
        guard let islands = Self.islands else {
            if let jsonFile = Bundle.module.url(forResource: "islands", withExtension: "json"),
                let data = try? Data(contentsOf: jsonFile) {
                let decoder = JSONDecoder()
                do {
                    let islands = try decoder.decode([MysteryIsland].self, from: data)
                    Self.islands = islands
                    return islands
                } catch {
                    return nil
                }
            }
            return nil
        }
        return islands
    }
}
