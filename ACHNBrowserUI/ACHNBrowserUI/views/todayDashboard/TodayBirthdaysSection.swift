//
//  TodayBirthdaysSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/8/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI

struct TodayBirthdaysSection: View {
    var body: some View {
        Section(header: SectionHeaderView(text: "Birthdays", icon: "gift.fill")) {
            NavigationLink(destination: Text("Birthdays Detail View")) {
                makeCell(month: "Oct", day: "30", title: "Wade", image: "Wade_HD")
            }
        }
    }
    
    private func makeCell(month: String, day: String, title: String, image: String) -> some View {
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
            
            Spacer()
            
            Image(image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .frame(width: 44)
            
        }
        .padding(.vertical, 8)
    }
    
    private func makeDateTitleIconCell(month: String, day: String, title: String, image: String = "") -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(month) \(day)")
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(Color("ACSecondaryText"))
                    .padding(.bottom, 4)
                
                Text(title)
                    .font(Font.system(.headline, design: .rounded))
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundColor(Color("ACText"))
                
            }
            
            if image != "" {
                Spacer()
                Image(image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 44)
            }
        }
        .padding(.vertical)
    }
}

struct TodayBirthdaysSection_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayBirthdaysSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
