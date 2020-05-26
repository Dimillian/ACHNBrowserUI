//
//  MysteryIslandsList.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 17/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct MysteryIslandsList: View {
    let islands = MysteryIsland.loadMysteryIslands()
    
    var body: some View {
        List(islands!) { island in
            NavigationLink(destination: MysteryIslandDetail(island: island)) {
                MysteryIslandRow(island: island)
            }
        }
        .navigationBarTitle(Text("Mystery islands"))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
    }
}

struct MysteryIslandsList_Previews: PreviewProvider {
    static var previews: some View {
        MysteryIslandsList()
    }
}
