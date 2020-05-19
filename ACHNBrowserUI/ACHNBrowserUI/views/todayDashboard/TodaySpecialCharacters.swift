//
//  TodaySpecialCharacters.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TodaySpecialCharacters: View {
    private var timeString: String {
        let f = DateFormatter()
        f.setLocalizedDateFormatFromTemplate("HH:mm")
        return f.string(from: Date())
    }
    
    private var currentIcon: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 9 {
            return "sunrise.fill"
        } else if hour < 17 {
            return "sun.max.fill"
        } else if hour < 20 {
            return "sunset.fill"
        } else {
            return "moon.stars.fill"
        }
    }
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Possible visitors", icon: "clock")) {
            VStack(alignment: .leading) {
                timeCard
                    .padding(.leading)
                    .padding(.trailing)
                
                charactersCard
            }
            .listRowInsets(EdgeInsets())
        }
    }
    
    private var timeCard: some View {
        HStack(spacing: 0) {
            Text("On").style(appStyle: .rowTitle)
            if !AppUserDefaults.shared.islandName.isEmpty {
                Text(" \(AppUserDefaults.shared.islandName) ")
                    .style(appStyle: .rowTitle)
            } else {
                Text(" your island")
                    .style(appStyle: .rowTitle)
            }
            Spacer()
            HStack {
                Image(systemName: currentIcon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                    .foregroundColor(.acHeaderBackground)
                Text(timeString).style(appStyle: .rowDetail)
            }
            .padding(16)
            .background(Color.acText.opacity(0.2))
            .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
    }
    
    private var charactersCard: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(SpecialCharacters.now(), id: \.self) { character in
                    Image(character.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }.padding(.bottom)
    }
}

struct TodaySpecialCharacters_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodaySpecialCharacters()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
    }
}
