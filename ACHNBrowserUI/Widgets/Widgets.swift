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

struct Provider: TimelineProvider {
    func timeline(with context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let date = Date()
        let entry = SimpleEntry(date: date)
        completion(Timeline(entries: [entry], policy: .after(Date())))
    }
    
    func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let date = Date()
        let entry = SimpleEntry(date: date)
        completion(entry)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
}

struct PlaceholderView : View {
    var body: some View {
        Text("Placeholder View")
    }
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.date, style: .time)
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
