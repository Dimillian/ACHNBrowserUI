//
//  TodayTasksSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/8/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI

struct TodayTasksSection: View {
    // @TODO: Check for AC Helper+ subscription
    @State private var userHasSubscription: Bool = true
    
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Today's Tasks", icon: "checkmark.seal.fill")) {
            NavigationLink(destination: Text("Event 2 Detail View")) {
                HStack {
                    
                    ZStack {
                        Circle()
                            .foregroundColor(Color("ACBackground"))
                        Image("icon-iron")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .frame(maxHeight: 44)
                    
                    ZStack {
                        Circle()
                            .foregroundColor(Color("ACBackground"))
                        Image("icon-bell")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .frame(maxHeight: 44)
                    
                    ZStack {
                        Circle()
                            .foregroundColor(Color("ACBackground"))
                        Image("icon-hardwood")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .frame(maxHeight: 44)
                    
                    ZStack {
                        Circle()
                            .foregroundColor(Color("ACBackground"))
                        Image("icon-fossil")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                    }
                    .frame(maxHeight: 44)
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical)
                .opacity(userHasSubscription ? 1.0 : 0.2)
                .overlay(premiumOverlay)
            }
        }
    }
    
    var premiumOverlay: some View {
        if userHasSubscription {
            return AnyView(EmptyView())
        } else {
            return AnyView(VStack {
                Text("This feature requires ") + Text("AC Helper+").fontWeight(.bold)
                Text("Learn more >")
            })
        }
    }
    
}

struct TodayTasksSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayTasksSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
