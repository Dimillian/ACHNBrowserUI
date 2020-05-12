//
//  TodayBirthdaysSection.swift
//  AC Helper UI Playground
//
//  Created by Matt Bonney on 5/8/20.
//  Copyright © 2020 Matt Bonney. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct TodayBirthdaysSection: View {
    var villagers: [Villager]

    var headerText: String {
        villagers.count > 1 ? "Today's Birthdays" : "Today's Birthday"
    }

    func birthdayDay(for villager: Villager) -> String {
        guard let birthday = villager.birthday else { return "" }
        let formatter = DateFormatter()

        formatter.setLocalizedDateFormatFromTemplate("d/M")
        let birthdayDate = formatter.date(from: birthday)!

        formatter.setLocalizedDateFormatFromTemplate("dd")
        return formatter.string(from: birthdayDate)
    }

    func birthdayMonth(for villager: Villager) -> String {
        guard let birthday = villager.birthday else { return "" }
        let formatter = DateFormatter()

        formatter.setLocalizedDateFormatFromTemplate("d/M")
        let birthdayDate = formatter.date(from: birthday)!

        formatter.setLocalizedDateFormatFromTemplate("MMM")
        return formatter.string(from: birthdayDate)
    }

    var body: some View {
        Section(header: SectionHeaderView(text: headerText, icon: "gift.fill")) {
            ForEach(villagers, id: \.id) { villager in
                NavigationLink(destination: VillagerDetailView(villager: villager)) {
                    self.makeCell(for: villager)
                }
            }
            .padding(.vertical)
        }
    }
    
    private func makeCell(for villager: Villager) -> some View {
        HStack {
            VStack {
                Text(birthdayMonth(for: villager))
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.acText)
                Text(birthdayDay(for: villager))
                    .font(.system(.subheadline, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.acText)
            }
            .frame(minWidth: 66)
            .padding(10)
            .background(Color.acText.opacity(0.2))
            .mask(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .padding(.trailing, 8)
            
            Text(villager.localizedName)
                .font(Font.system(.headline, design: .rounded))
                .fontWeight(.semibold)
                .lineLimit(2)
                .foregroundColor(.acText)
            
            Spacer()

            ItemImage(path: ACNHApiService.BASE_URL.absoluteString +
                ACNHApiService.Endpoint.villagerIcon(id: villager.id).path(),
                      size: 44)
            
        }
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
                    .foregroundColor(.acText)
                
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

//struct TodayBirthdaysSection_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            List {
//                TodayBirthdaysSection(villager: Villager))
//            }
//            .listStyle(GroupedListStyle())
//            .environment(\.horizontalSizeClass, .regular)
//        }
//        .previewLayout(.fixed(width: 375, height: 500))
//    }
//}
