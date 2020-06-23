//
//  MysteryIslandDetail.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct MysteryIslandDetail: View {
    let island: MysteryIsland
    
    var body: some View {
        List {
            Section {
                HStack {
                    Spacer()
                    Image(island.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250)
                        .cornerRadius(8)
                        .padding()
                    Spacer()
                }
                .listRowBackground(Color.acSecondaryBackground)
                
                Group {
                    makeInfoCell(title: "Chance", detail: "\(island.chance) %")
                    makeInfoCell(title: "Trees", detail: island.trees.capitalized)
                    makeInfoCell(title: "Flowers", detail: island.flowers.capitalized)
                    makeInfoCell(title: "Rocks", detail: "\(island.rocks)")
                    makeInfoCell(title: "Rocks Type", detail: island.rocks_type.capitalized)
                    makeInfoCell(title: "Fish", detail: island.fish.capitalized)
                    makeInfoCell(title: "Insects", detail: island.insects.capitalized)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description").style(appStyle: .rowTitle)
                        Text(LocalizedStringKey(island.description)).style(appStyle: .rowDescription)
                    }
                }
                .listRowBackground(Color.acSecondaryBackground)
            }
        }
        .navigationBarTitle(Text(LocalizedStringKey(island.name)))
        .listStyle(InsetGroupedListStyle())
    }
    
    private func makeInfoCell(title: LocalizedStringKey,
                              detail: String) -> some View {
        HStack() {
            Text(title)
                .style(appStyle: .rowTitle)
            Spacer()
            Text(LocalizedStringKey(detail))
                .style(appStyle: .rowDetail)
        }
    }
}

struct MysteryIslandDetail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            MysteryIslandDetail(island: MysteryIsland.loadMysteryIslands()!.randomElement()!)
        }
    }
}
