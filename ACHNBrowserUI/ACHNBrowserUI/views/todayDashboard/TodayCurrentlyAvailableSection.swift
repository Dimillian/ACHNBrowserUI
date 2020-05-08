//
//  TodayCurrentlyAvailableSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI

struct TodayCurrentlyAvailableSection: View {
    private enum CellType: String {
        case fish = "Fish"
        case bugs = "Ins"
    }
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Currently Available", icon: "calendar")) {
            NavigationLink(destination: NavigationView { List { Text("Event 2 Detail View") }}) {
                HStack(alignment: .top) {
                    makeCell(for: .fish, available: 34, numberNew: 8)
                    Divider()
                    makeCell(for: .bugs, available: 34, numberNew: 0)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
    
    private func makeCell(for type: CellType, available: Int, numberNew: Int = 0) -> some View {
        VStack(spacing: 0) {
            Image("\(type.rawValue)\(self.dayNumber())")
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: 66)
            
            Group {
                // @TODO: Rename all the insect images from "Ins00" to "Bugs00"
                type == .bugs ? Text("\(available) Bugs") : Text("\(available) \(type.rawValue)")
            }
            .font(.system(.headline, design: .rounded))
            .foregroundColor(Color("ACText"))
                        
            if numberNew > 0 {
                Text("\(numberNew) NEW")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("ACText"))
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(Capsule().foregroundColor(Color("ACText").opacity(0.2)))
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
