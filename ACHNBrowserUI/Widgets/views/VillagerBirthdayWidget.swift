//
//  VillagerBirthdayWidget.swift
//  WidgetsExtension
//
//  Created by Thomas Ricouard on 25/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import WidgetKit
import Backend
import SDWebImageSwiftUI

struct VillagerBirthdayWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var model: WidgetModel
    
    private var today: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M"
        return formatter.string(from: Date())
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
    
    private var villager: Villager? {
        model.villagers.filter( { $0.birthday == today } ).first
    }
    
    @ViewBuilder
    var body: some View {
        if let villager = villager {
            Group {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
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
                        
                        if let url = URL(string: ACNHApiService.BASE_URL.absoluteString +
                                            ACNHApiService.Endpoint.villagerIcon(id: villager.id).path()) {
                            WebImage(url: url)
                                .resizable()
                                .renderingMode(.original)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 60, height: 60)
                                .animation(.spring())
                        }
                        Spacer()
                    }
                    Spacer()
                }
            }.background(Color.acBackground)
        }
    }
}
struct VillagerBirthdayWidget: Widget {
    private let kind: String = "VillagerBirthday"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: WidgetProvider(),
                            placeholder: LoadingView()) { entry in
            VillagerBirthdayWidgetView(model: entry)
        }
        .configurationDisplayName("Villager birthday")
        .description("Today villagers birthday")
        .supportedFamilies([.systemMedium])
    }
}
