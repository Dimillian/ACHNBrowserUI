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
import SDWebImageSwiftUI

struct Provider: TimelineProvider {
    let items = Items.shared
    
    func timeline(with context: Context, completion: @escaping (Timeline<WidgetModel>) -> ()) {
        let fishes = items.categories[.fish]?.filterActiveThisMonth().filter{ $0.isActiveAtThisHour() }
        let now = Date()
        let entry = WidgetModel(date: now, availableFishes: fishes)
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: now)!
        completion(Timeline(entries: [entry], policy: .after(nextUpdateDate)))
    }
    
    func snapshot(with context: Context, completion: @escaping (WidgetModel) -> ()) {
        let entry = WidgetModel(date: Date(), availableFishes: nil)
        completion(entry)
    }
}
struct PlaceholderView : View {
    var body: some View {
        VStack {
            Text("Loading...")
        }
    }
}

@main
struct Widgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        ActiveFishWidget()
        VillagerBirthdayWidget()
    }
}
