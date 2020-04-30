//
//  Listing.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/16/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation

public struct Listing: Decodable, Identifiable {
    public enum Status: String, Decodable {
        case online, offline
    }
    
    public struct Pricing: Decodable {
        public var listingId: String
        public var bells: Int?
        public var name: String?
        public var type: String?
        public var category: String?
        public var img: URL?
    }
    
    public var id: String
    public var itemId: String
    public var name: String?
    public var amount: Int
    public var active: Bool
    public var selling: Bool
    public var makeOffer: Bool
    public var needMaterials: Bool
    public var username: String
    public var discord: String?
    public var img: URL?
    public var status: Status?
    public var prices: [Pricing]?
    public var rating: String?
}
