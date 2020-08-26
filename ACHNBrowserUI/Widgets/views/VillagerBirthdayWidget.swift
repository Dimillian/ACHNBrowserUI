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

struct VillagerBirthdayWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    let model: WidgetModel
            
    @ViewBuilder
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                makeSmallWidget(villager: model.villager)
            case .systemMedium:
                makeMediumWidget(villager: model.villager)
            case .systemLarge:
                Text("Not supported yet.")
            @unknown default:
                Text("Not supported yet.")
            }
            
        }
        .widgetURL(URL(string: "achelperapp://villager/\(model.villager?.fileName ?? "null")")!)
    }
    
    private func makeDayStamp(villager: Villager?) -> some View {
        VStack {
            Text(villager?.birthdayMonth() ?? "...")
                .font(.system(.caption, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.acText)
            Text(villager?.birthdayDay() ?? "...")
                .font(.system(.subheadline, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.acText)
        }
        .frame(minWidth: 66)
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 16, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/).fill(Color.acText.opacity(0.2)))
        .padding(.trailing, 8)
    }
    
    @ViewBuilder
    private func makeIcon(villager: Villager?, size: CGFloat) -> some View {
        if let image = model.villagerImage {
            Image(uiImage: image)
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
        } else {
            Rectangle()
                .fill(Color.gray)
                .clipShape(Circle())
                .frame(width: size, height: size)
        }
    }
    
    private func makeName(villager: Villager?) -> some View {
        Text(villager?.localizedName ?? "Loading...")
            .font(Font.system(.headline, design: .rounded))
            .fontWeight(.semibold)
            .lineLimit(2)
            .foregroundColor(.acText)
    }
    
    private func makeSmallWidget(villager: Villager?) -> some View {
        Group {
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    Spacer()
                    makeDayStamp(villager: villager)
                    makeIcon(villager: villager, size: 40)
                    makeName(villager: villager)
                    Spacer()
                }
                Spacer()
            }
        }.background(Color.acBackground)
    }
    
    private func makeMediumWidget(villager: Villager?) -> some View {
        Group {
            VStack {
                Spacer()
                HStack {
                    Image("icon-present")
                        .resizable()
                        .frame(width: 40, height: 40)
                    Text("Today's Birthday")
                        .font(Font.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.acText)
                }
                Spacer()
                HStack {
                    Spacer()
                    makeDayStamp(villager: villager)
                    makeName(villager: villager)
                    Spacer()
                    makeIcon(villager: villager, size: 60)
                    Spacer()
                }
                Spacer()
            }
        }.background(Color.acBackground)
    }
}

struct VillagerBirthdayWidget: Widget {
    private let kind: String = "VillagerBirthday"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: WidgetProvider()) { entry in
            VillagerBirthdayWidgetView(model: entry)
        }
        .configurationDisplayName("Villager birthday")
        .description("Today villagers birthday")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
