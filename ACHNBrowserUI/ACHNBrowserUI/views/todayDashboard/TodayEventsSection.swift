//
//  TodayEventsSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/8/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI

struct TodayEventsSection: View {
    // @TODO: Need to pass in an array of some type of event object
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Events", icon: "flag.fill")) {
            NavigationLink(destination: Text("Event 1 Detail View")) {
                makeCell(month: "May", day: "1-7", title: "May Day")
            }
            
            NavigationLink(destination: Text("Event 2 Detail View")) {
                makeCell(month: "May", day: "18-31", title: "International Museum Day")
            }
        }
    }

    private func makeCell(month: String, day: String, title: String) -> some View {
        HStack {
            VStack {
                Text("\(month)")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("ACText"))
                Text("\(day)")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("ACText"))
            }
            .frame(minWidth: 66)
            .padding(10)
            .background(Color("ACText").opacity(0.2))
            .mask(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(.trailing, 8)
            
            Text(title)
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundColor(Color("ACText"))
            
        }
        .padding(.vertical, 8)
    }
}

struct TodayEventsSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayEventsSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
