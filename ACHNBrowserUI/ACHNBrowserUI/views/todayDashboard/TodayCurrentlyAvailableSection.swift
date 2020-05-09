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
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject var viewModel: DashboardViewModel
    
    private enum CellType: String {
        case fish = "Fish"
        case bugs = "Ins"
    }
    
    // MARK: - Bug Calculations
    private var bugsCaught: Int {
        if !viewModel.bugs.isEmpty {
            return collection.caughtIn(list: viewModel.bugs)
        } else {
            return 1
        }
    }
    
    private var bugsAvailable: Int {
        if !viewModel.bugs.isEmpty {
            return viewModel.bugs.filterActive().count
        } else {
            return 1
        }
    }
    
    private var newBugs: Int {
        viewModel.bugs.filterActive().filter{ $0.isNewThisMonth() }.count
    }
    
    // MARK: - Fish Calculations
    private var fishCaught: Int {
        if !viewModel.fishes.isEmpty {
            return collection.caughtIn(list: viewModel.fishes)
        } else {
            return 1
        }
    }
    
    private var fishAvailable: Int {
        if !viewModel.fishes.isEmpty {
            return viewModel.fishes.filterActive().count
        } else {
            return 1
        }
    }
    
    private var newFish: Int {
        viewModel.fishes.filterActive().filter{ $0.isNewThisMonth() }.count
    }
    
    // MARK: - Body
    var body: some View {
        Section(header: SectionHeaderView(text: "Currently Available", icon: "calendar")) {
            NavigationLink(destination: ActiveCrittersView(activeFishes: viewModel.fishes.filterActive(),
                                                           activeBugs: viewModel.bugs.filterActive())) {
                HStack(alignment: .top) {
                    makeCell(for: .fish, caught: fishCaught, available: fishAvailable, numberNew: newFish)
                    Divider()
                    makeCell(for: .bugs, caught: bugsCaught, available: bugsAvailable, numberNew: newBugs)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
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
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
