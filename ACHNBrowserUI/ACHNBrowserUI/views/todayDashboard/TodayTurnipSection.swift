//
//  TodayTurnipSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI

struct TodayTurnipSection: View {
    var body: some View {
        // MARK: - Turnip Card
        Section(header: SectionHeaderView(text: "Turnips", icon: "dollarsign.circle.fill")) {
            NavigationLink(destination: Text("Event 2 Detail View")) {
                HStack {
                    Image("icon-turnip")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(maxWidth: 33)
                    
                    Group {
                        Text("Today's average price should be around ")
                            + Text("129 Bells")
                                .foregroundColor(Color("ACSecondaryText"))
                            + Text(" in the morning, and ")
                            + Text("85 Bells")
                                .foregroundColor(Color("ACSecondaryText"))
                            + Text(" this afternoon.")
                    }
                    .font(.system(.body, design: .rounded))
                        //                            .fontWeight(.medium)
                        .foregroundColor(Color("ACText"))
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
            }
        }
    }
}

struct TodayTurnipSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayTurnipSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
