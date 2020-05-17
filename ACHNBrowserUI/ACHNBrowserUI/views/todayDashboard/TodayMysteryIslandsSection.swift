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
    let randomIsland = MysteryIsland.loadMysteryIslands()?.randomElement()
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Mystery Islands", icon: "sun.haze.fill")) {
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
        }
    }
}

struct TodayMysteryIslandsSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayMysteryIslandsSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
