//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 08/05/2020.
//

import Foundation

public struct UserList: Codable, Identifiable {
    public var id = UUID()
    public var name: String = ""
    public var description: String = ""
    public var icon: String? = nil
    public var items: [Item] = []
    
    public init() {

    }
}
