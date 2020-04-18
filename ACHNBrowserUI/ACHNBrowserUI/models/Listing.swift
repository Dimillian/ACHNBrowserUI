//
//  Listing.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/16/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

struct Listing: Decodable, Identifiable {
    enum Status: String, Decodable {
        case online, offline
    }
    
    struct Pricing: Decodable {
        var listingId: String
        var bells: Int?
        var name: String?
        var type: String?
        var category: String?
        var img: URL?
    }
    
    var id: String
    var itemId: String
    var name: String?
    var amount: Int
    var active: Bool
    var selling: Bool
    var makeOffer: Bool
    var needMaterials: Bool
    var username: String
    var discord: String?
    var img: URL?
    var status: Status?
    var prices: [Pricing]?
    var rating: String?
}
