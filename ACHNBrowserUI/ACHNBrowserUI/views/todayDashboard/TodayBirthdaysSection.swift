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
    @Environment(\.currentDate) private static var currentDate
    @StateObject private var viewModel = VillagersViewModel(currentDate: Self.currentDate)

    var headerText: String {
        viewModel.todayBirthdays.count > 1 ? "Today's Birthdays" : "Today's Birthday"
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                RowLoadingView()
            } else if viewModel.todayBirthdays.isEmpty {
                Text("No Birthday today...")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.acText)
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
                Text(villager.birthdayMonth())
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.acText)
                Text(villager.birthdayDay())
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
            .listStyle(InsetGroupedListStyle())
        }
        .previewLayout(.fixed(width: 375, height: 500))
    }
}
