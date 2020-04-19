//
//  ActiveCrittersView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct ActiveCrittersView: View {
    enum Tab: String, CaseIterable {
        case fishes = "Fishes"
        case bugs = "Bugs"
    }
    
    let activeFishes: [Item]
    let activeBugs: [Item]
    
    @State private var selectedTab = Tab.fishes
    
    var body: some View {
        List {
            Picker(selection: $selectedTab, label: Text("")) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    Text(tab.rawValue).tag(tab.rawValue)
                }
            }.pickerStyle(SegmentedPickerStyle())
            ForEach(selectedTab == .fishes ? activeFishes : activeBugs) { critter in
                ItemRowView(item: critter)
            }
        }.listStyle(GroupedListStyle())
        .navigationBarTitle("Active Critters")
    }
}

struct ActiveCrittersView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCrittersView(activeFishes: [], activeBugs: [])
    }
}
