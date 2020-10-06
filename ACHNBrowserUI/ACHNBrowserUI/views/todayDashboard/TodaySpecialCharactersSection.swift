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
    @Environment(\.currentDate) private var currentDate
    @State private var selectedCharacter: SpecialCharacters?
    @Namespace private var namespace
    
    private var currentIcon: String {
        let hour = Calendar.current.component(.hour, from: currentDate)
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
        VStack(alignment: .leading) {
            timeCard
                .padding(.leading)
                .padding(.trailing)
            
            charactersCard
        }.listRowInsets(EdgeInsets())
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
                Text(currentDate, style: .time)
                    .style(appStyle: .rowDetail)
            }
            .padding(16)
            .background(Color.acText.opacity(0.2))
            .mask(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.top, 8)
            .padding(.bottom, 8)
        }
    }
    
    @ViewBuilder
    private var charactersCard: some View {
        if let selected = selectedCharacter {
            HStack {
                Spacer()
                VStack(spacing: 12) {
                    Image(selected.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .matchedGeometryEffect(id: selected.rawValue, in: namespace)
                    
                    Text(selectedCharacter!.localizedName())
                        .style(appStyle: .rowTitle)
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
                Spacer()
            }.padding()
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(SpecialCharacters.forDate(currentDate), id: \.self) { character in
                        Image(character.rawValue)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .onTapGesture {
                                withAnimation(.interactiveSpring()) {
                                    self.selectedCharacter = character
                                }
                            }
                            .matchedGeometryEffect(id: character.rawValue, in: namespace)
                    }
                }
                .padding(.leading)
                .padding(.trailing)
            }.padding(.bottom)
        }
    }
}

struct TodaySpecialCharacters_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodaySpecialCharactersSection()
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}
