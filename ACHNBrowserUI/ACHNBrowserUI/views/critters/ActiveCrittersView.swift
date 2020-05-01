//
//  ActiveCrittersView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

enum Tab: String, CaseIterable {
    case fishes = "Fishes"
    case bugs = "Bugs"
}

struct ActiveCritterSections: View {
    @EnvironmentObject private var collection: UserCollection
    @Binding var selectedTab: Tab

    let activeFishes: [Item]
    let activeBugs: [Item]
    
    func toCatchCritter(critters: [Item]) -> [Item] {
        critters.filter{ !collection.critters.contains($0) }
    }
    
    func caughtCritters(critters: [Item]) -> [Item] {
        critters.filter{ collection.critters.contains($0) }
    }
    
    func newThisMonth(critters: [Item]) -> [Item] {
        critters.filter{ $0.isNewThisMonth() && !collection.critters.contains($0) }
    }
    
    private func sectionContent(critter: Item) -> some View {
        NavigationLink(destination: ItemDetailView(item: critter)) {
            ItemRowView(displayMode: .big, item: critter)
        }
    }
    
    private func makeSectionOrPlaceholder(title: String, critters: [Item]) -> some View {
        Group {
            if critters.isEmpty {
                Text("You caught them all!").font(.body).fontWeight(.bold)
            } else {
                Section(header: SectionHeaderView(text: title)) {
                    ForEach(critters, content: sectionContent)
                }
            }
        }
    }
    
    var body: some View {
        Group {
            makeSectionOrPlaceholder(title: "New this month",
                                     critters: newThisMonth(critters: selectedTab == .fishes ? activeFishes : activeBugs))
            makeSectionOrPlaceholder(title: "To catch",
                                     critters: toCatchCritter(critters: selectedTab == .fishes ? activeFishes : activeBugs))
            Section(header: SectionHeaderView(text: "Caught")) {
                ForEach(caughtCritters(critters: selectedTab == .fishes ? activeFishes : activeBugs),
                        content: sectionContent)
            }
        }
    }
}

struct ActiveCrittersView: View {
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
            ActiveCritterSections(selectedTab: $selectedTab,
                                  activeFishes: activeFishes,
                                  activeBugs: activeBugs)
        }
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .navigationBarTitle("Active Critters")
    }
}

struct ActiveCrittersView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveCrittersView(activeFishes: [], activeBugs: [])
    }
}
