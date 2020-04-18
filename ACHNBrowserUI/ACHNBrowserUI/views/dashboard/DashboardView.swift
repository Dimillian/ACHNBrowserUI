//
//  DashboardView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/18/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        List {
            makeAvailableCritterSection()
            makeCritterCollectionProgressSection()
            makeCatalogSection()
            makeTopTurnipSection()
            makeRecentFavoritesSection()
            makeRecentNookazonListings()
        }
    }
}

extension DashboardView {
    func makeAvailableCritterSection() -> some View {
        Text("available critters")
    }
    
    func makeCritterCollectionProgressSection() -> some View {
        Text("critter progress")
    }
    
    func makeCatalogSection() -> some View {
        Text("catalog")
    }
    
    func makeTopTurnipSection() -> some View {
        Text("turnips!")
    }
    
    func makeRecentFavoritesSection() -> some View {
        Text("Faves")
    }
    
    func makeRecentNookazonListings() -> some View {
        Text("recent nookazon listings")
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
