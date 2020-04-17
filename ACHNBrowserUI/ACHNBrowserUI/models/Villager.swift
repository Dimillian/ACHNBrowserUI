//
//  Villager.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

struct Villager: Identifiable, Codable {
    let id: Int
    let name: [String: String]
    let personality: String
    let birdthday: String?
    let gender: String
    let species: String
}
