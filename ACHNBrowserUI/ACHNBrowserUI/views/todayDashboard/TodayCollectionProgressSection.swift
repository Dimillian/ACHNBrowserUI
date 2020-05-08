//
//  TodayCollectionProgressSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/6/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI

struct TodayCollectionProgressSection: View {
    
    @State private var barHeight: CGFloat = 12
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Collection Progress", icon: "chart.pie.fill")) {
            VStack {
                progressRow(iconName: "Fish28", has: 1, outOf: 44)
                progressRow(iconName: "Ins13", has: 20, outOf: 38)
                progressRow(iconName: "icon-fossil", has: 8, outOf: 77)
                shareButton.padding(.top, 4)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
        }
    }
    
    var shareButton: some View {
        Button(action: { } ) {
            HStack {
                Image(systemName: "square.and.arrow.up").padding(.bottom, 4)
                Text("Share")
            }
            .font(Font.system(size: 16, weight: .bold, design: .rounded))
        }
        .accentColor(Color("ACText"))
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .foregroundColor(Color("ACBackground"))
        )
    }
    
    func progressRow(iconName: String, has: Int, outOf: Int) -> some View {
        // So. You're going to wonder why I take values in as Ints, then convert
        // them to CGFloats immediately.
        //
        // Basically:
        // 1. You only have whole numbers of items in your collection, so that
        //    makes sense, logically.
        // 2. If, when calculating the bar width, I try to cast them in-line to
        //    CGFloats, the Xcode 11 compiler totally loses it's mind, and fails
        //    to compile.
        //
        // -- MATT BONNEY 2020-05-06 18:26
        
        let x = CGFloat(has)
        let y = CGFloat(outOf)
        
        return HStack {
            Image(iconName)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(height: 24)
            
            Group {
                GeometryReader { g in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .foregroundColor(Color("ACText").opacity(0.2))
                            .frame(width: g.size.width)
                        Capsule()
                            .foregroundColor(Color("ACHeaderBackground"))
                            .frame(width: (g.size.width * x/y) > 0 ? max(self.barHeight, (g.size.width * x/y)) : 0)
                        // Makes sure the bar will make a nice circle at it's smallest size
                    }
                }
            }
            .frame(height: self.barHeight)
            
            Text("\(has) / \(outOf)")
                .font(Font.system(size: 12, weight: Font.Weight.semibold, design: Font.Design.rounded).monospacedDigit())
                .foregroundColor(Color("ACText"))
        }
    }
}

struct TodayCollectionProgressSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayCollectionProgressSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
