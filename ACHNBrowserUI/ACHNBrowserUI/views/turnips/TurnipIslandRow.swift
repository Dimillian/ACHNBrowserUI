//
//  TurnipIslandRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 27/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TurnipIslandRow: View {
    let island: Island
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(island.name)
                .foregroundColor(.text)
                .font(.headline)
            Text(island.islandTime.description)
                .foregroundColor(.secondaryText)
                .font(.subheadline)
            HStack {
                Spacer()
                island.fruit.image
                Spacer()
                Divider()
                Spacer()
                Text("\(island.turnipPrice)")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.text)
                Group {
                    Spacer()
                    Divider()
                    Spacer()
                }
                Text(island.hemisphere.rawValue.localizedCapitalized)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.text)
                Spacer()
            }
        }
    }
}
