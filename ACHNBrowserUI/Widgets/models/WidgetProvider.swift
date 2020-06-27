//
//  WidgetProvider.swift
//  WidgetsExtension
//
//  Created by Thomas Ricouard on 26/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents
import Backend
import UI
import SDWebImageSwiftUI
import Combine

private class ProviderHolder {
    var apiPublisher: AnyPublisher<[String: Villager], Never>?
    var cancellable: AnyCancellable?
}
struct WidgetProvider: TimelineProvider {
    let items = Items.shared
    fileprivate let providerHolder = ProviderHolder()
    
    func timeline(with context: Context, completion: @escaping (Timeline<WidgetModel>) -> ()) {
        let fishes = items.categories[.fish]?.filterActiveThisMonth().filter{ $0.isActiveAtThisHour() }
        providerHolder.apiPublisher = ACNHApiService.fetch(endpoint: .villagers)
            .subscribe(on: DispatchQueue.global())
            .replaceError(with: [:])
            .eraseToAnyPublisher()
        providerHolder.cancellable = providerHolder.apiPublisher?
            .receive(on: DispatchQueue.main)
            .map{ $0.map{ $0.1}.sorted(by: { $0.id > $1.id }) }
            .sink(receiveValue: {
                let now = Date()
                let entry = WidgetModel(date: now,
                                        availableFishes: fishes?.shuffled().prefix(upTo: 3).map{ $0 },
                                        villagers: $0)
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: now)!
                completion(Timeline(entries: [entry], policy: .after(nextUpdateDate)))
            })
    }
    
    func snapshot(with context: Context, completion: @escaping (WidgetModel) -> ()) {
        let entry = WidgetModel(date: Date(), availableFishes: nil, villagers: [])
        completion(entry)
    }
}
