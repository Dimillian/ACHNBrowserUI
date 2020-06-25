//
//  VillagerBirthdayWidget.swift
//  WidgetsExtension
//
//  Created by Thomas Ricouard on 25/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import WidgetKit

struct VillagerBirthdayWidgetView: View {
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var model: WidgetModel
    
    var body: some View {
        Text("Hello world")
    }
}
struct VillagerBirthdayWidget: Widget {
    private let kind: String = "VillagerBirthday"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider(),
                            placeholder: PlaceholderView()) { entry in
            VillagerBirthdayWidgetView(model: entry)
        }
        .configurationDisplayName("Villager birthday")
        .description("Today villagers birthday")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
