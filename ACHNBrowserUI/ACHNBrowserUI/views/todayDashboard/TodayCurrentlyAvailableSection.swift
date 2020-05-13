//
//  TodayCurrentlyAvailableSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import Backend

struct TodayCurrentlyAvailableSection: View {
    @EnvironmentObject private var items: Items
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject var viewModel: DashboardViewModel
    
    private enum CellType: String {
        case fish = "Fish"
        case bugs = "Ins"
    }
    
    // MARK: - Bug Calculations
    private var bugsAvailable: [Item] {
        items.categories[.bugs]?.filterActive() ?? []
    }
    
    private var newBugs: [Item] {
        items.categories[.bugs]?.filterActive().filter{ $0.isNewThisMonth() } ?? []
    }
    
    // MARK: - Fish Calculations
    private var fishAvailable: [Item] {
        items.categories[.fish]?.filterActive() ?? []
    }
    
    private var newFish: [Item] {
        items.categories[.fish]?.filterActive().filter{ $0.isNewThisMonth() } ?? []
    }
    
    // MARK: - Body
    var body: some View {
        Section(header: SectionHeaderView(text: "Currently Available", icon: "calendar")) {
            if !fishAvailable.isEmpty && !bugsAvailable.isEmpty {
                NavigationLink(destination: ActiveCrittersView(activeFishes: fishAvailable,
                                                               activeBugs: bugsAvailable))
                {
                    HStack(alignment: .top) {
                        makeCell(for: .fish,
                                 caught: collection.itemsIn(category: .fish),
                                 available: fishAvailable.count,
                                 numberNew: newFish.count)
                        Divider()
                        makeCell(for: .bugs,
                                 caught: collection.itemsIn(category: .bugs),
                                 available: bugsAvailable.count,
                                 numberNew: newBugs.count)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            } else {
                RowLoadingView(isLoading: .constant(true))
            }
        }
    }
    
    private func makeCell(for type: CellType, caught: Int, available: Int, numberNew: Int = 0) -> some View {
        VStack(spacing: 0) {
            Image("\(type.rawValue)\(self.dayNumber())")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 48)
            
            Group {
                // @TODO: Rename all the insect images from "Ins00" to "Bugs00"
                type == .bugs ? Text("\(caught)/\(available) Bugs") : Text("\(caught)/\(available) Fish")
            }
            .font(.system(.headline, design: .rounded))
            .foregroundColor(.acText)
                        
            if numberNew > 0 {
                Text("\(numberNew) NEW")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.acText)
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(Capsule().foregroundColor(Color.acText.opacity(0.2)))
                    .padding(.top)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func dayNumber() -> Int {
        return Calendar.current.dateComponents([.day], from: Date()).day ?? 0
    }
}

struct TodayCurrentlyAvailableSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayCurrentlyAvailableSection(viewModel: DashboardViewModel())
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .environmentObject(UserCollection.shared)
        .environmentObject(Items.shared)
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
