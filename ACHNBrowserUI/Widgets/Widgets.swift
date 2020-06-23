//
//  Widgets.swift
//  Widgets
//
//  Created by Thomas Ricouard on 23/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import Backend
import UI

struct Provider: TimelineProvider {
    let items = Items.shared
    
    func timeline(with context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let fish = items.categories[.fish]?.filterActiveThisMonth().filter{ $0.isActiveAtThisHour() }.first
        
        let entry = SimpleEntry(date: Date(), critter: fish)
        completion(Timeline(entries: [entry], policy: .after(Date())))
    }
    
    func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let fish = items.categories[.fish]?.filterActiveThisMonth().filter{ $0.isActiveAtThisHour() }.first
        
        let entry = SimpleEntry(date: Date(), critter: fish)
        
        completion(entry)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public let critter: Item?
}

struct PlaceholderView : View {
    var body: some View {
        VStack {
            Text("Placeholder View")
        }
    }
}

struct WidgetsEntryView : View {
    var entry: SimpleEntry

    var body: some View {
        VStack {
            // ItemImage(path: entry.critter?.finalImage, size: 100)
            Text(entry.critter?.name ?? "loading...")
        }
    }
}

@main
struct Widgets: Widget {
    private let kind: String = "Widgets"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: Provider(),
                            placeholder: PlaceholderView()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
