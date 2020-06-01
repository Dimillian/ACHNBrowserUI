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
    @ObservedObject private var viewModel = ActiveCrittersViewModel()
    
    private enum CellType: String {
        case fish = "Fish"
        case bugs = "Ins"
    }
    
    // MARK: - Body
    var body: some View {
        Section(header: SectionHeaderView(text: "Currently Available", icon: "calendar")) {
            if !viewModel.activeBugs.isEmpty && !viewModel.activeFish.isEmpty {
                NavigationLink(destination: ActiveCrittersView())
                {
                    HStack(alignment: .top) {
                        makeCell(for: .fish,
                                 caught: viewModel.caughFish.count,
                                 available: viewModel.activeFish.count,
                                 numberNew: viewModel.newFishThisMonth.count)
                        Divider()
                        makeCell(for: .bugs,
                                 caught: viewModel.caughBugs.count,
                                 available: viewModel.activeBugs.count,
                                 numberNew: viewModel.newBugsThisMonth.count)
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
                TodayCurrentlyAvailableSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
