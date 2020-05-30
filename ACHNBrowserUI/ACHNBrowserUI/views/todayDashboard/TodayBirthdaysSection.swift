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
    @ObservedObject private var viewModel = VillagersViewModel()

    var headerText: String {
        viewModel.todayBirthdays.count > 1 ? "Today's Birthdays" : "Today's Birthday"
    }
    
    private func formattedDate(for villager: Villager) -> Date {
        guard let birthday = villager.birthday else { return Date() }
        let formatter = DateFormatter()
        
        formatter.dateFormat = "d/M"
        return formatter.date(from: birthday) ?? Date()
    }

    private func birthdayDay(for villager: Villager) -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dd")
        return formatter.string(from: formattedDate(for: villager))
    }

    private func birthdayMonth(for villager: Villager) -> String {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMM")
        return formatter.string(from: formattedDate(for: villager))
    }

    var body: some View {
        Section(header: SectionHeaderView(text: headerText, icon: "gift.fill")) {
            if viewModel.todayBirthdays.isEmpty {
                RowLoadingView(isLoading: .constant(true))
            } else {
                ForEach(viewModel.todayBirthdays, id: \.id) { villager in
                    NavigationLink(destination: LazyView(VillagerDetailView(villager: villager))) {
                        self.makeCell(for: villager)
                    }
                }
                .padding(.vertical)
            }
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
