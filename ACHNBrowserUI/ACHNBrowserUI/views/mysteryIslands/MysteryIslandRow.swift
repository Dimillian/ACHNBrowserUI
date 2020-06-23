//
//  MysteryIslandRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct MysteryIslandRow: View {
    let island: MysteryIsland
    
    var body: some View {
        HStack {
            Image(island.image)
                .resizable()
                .frame(width: 75, height: 75)
                .cornerRadius(8)
            VStack(alignment: .leading, spacing: 4) {
                Text(LocalizedStringKey(island.name))
                    .style(appStyle: .rowTitle)
                HStack(spacing: 0) {
                    Text("\(island.chance)% chance")
                        .style(appStyle: .rowDescription)
                    island.max_visit.map { visits in
                        Text(" - max \(visits) visit")
                            .style(appStyle: .rowDescription)
                    }
                }
                Text("Flowers: \(NSLocalizedString(island.flowers.capitalized, comment: ""))")
                    .style(appStyle: .rowDescription)
                Text("Trees: \(NSLocalizedString(island.trees.capitalized, comment: ""))")
                    .style(appStyle: .rowDescription)
            }
        }
    }
}

struct MysteryIslandRow_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                MysteryIslandRow(island: MysteryIsland.loadMysteryIslands()!.randomElement()!)
            }
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
