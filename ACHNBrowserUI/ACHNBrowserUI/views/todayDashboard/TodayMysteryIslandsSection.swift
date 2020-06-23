//
//  TodayMysteryIslandsSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TodayMysteryIslandsSection: View {
    @State var randomIsland = MysteryIsland.loadMysteryIslands()?.randomElement()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Take your chance and go visit some mystery island!")
                .style(appStyle: .rowDescription)
                .lineLimit(2)
                .frame(maxHeight: .infinity)
                .padding(.top, 8)
            randomIsland.map{ island in
                NavigationLink(destination: MysteryIslandsList()) {
                    MysteryIslandRow(island: island)
                }
            }
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
        .padding(.bottom, 8)
    }
}

struct TodayMysteryIslandsSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayMysteryIslandsSection()
            }
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
