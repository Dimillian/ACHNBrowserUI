//
//  TodaySpecialCharactersSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Backend

struct TodaySpecialCharactersSection: View {
    @State private var selectedCharacter: SpecialCharacters?
    
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
            ZStack {
                VStack(alignment: .leading) {
                    timeCard
                        .padding(.leading)
                        .padding(.trailing)
                    
                    charactersCard
                }
                selectedCharacterPopup
            }.listRowInsets(EdgeInsets())
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
                Text(timeString)
                    .style(appStyle: .rowDetail)
            }
            .frame(width: 90)
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
                        .onTapGesture {
                            withAnimation(.spring(response: 0.30, dampingFraction: 0.6, blendDuration: 0)) {
                                self.selectedCharacter = character
                            }
                    }
                }
            }
            .padding(.leading)
            .padding(.trailing)
        }.padding(.bottom)
    }
    
    private var selectedCharacterPopup: some View {
        Group {
            if selectedCharacter != nil {
                VStack(spacing: 12) {
                    Text(selectedCharacter!.localizedName())
                        .style(appStyle: .sectionHeader)
                    Text(selectedCharacter!.timeOfTheDay())
                        .style(appStyle: .rowDetail)
                    Button(action: {
                        self.selectedCharacter = nil
                    }){
                        Text("Close")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainRoundedButton())
                    .accentColor(.acTabBarTint)
                }
                .frame(width: 200)
                .padding(16)
                .background(Color.acText.opacity(0.95).cornerRadius(16))
                .transition(.scale)
            } else {
                EmptyView()
            }
        }
    }
}

struct TodaySpecialCharacters_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodaySpecialCharactersSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
        }
    }
}
