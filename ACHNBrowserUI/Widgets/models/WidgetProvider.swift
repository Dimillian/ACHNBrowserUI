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
    let collection = UserCollection(iCloudDisabled: false, fromSharedURL: true)
    fileprivate let providerHolder = ProviderHolder()
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<WidgetModel>) -> Void) {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M"
        let today = formatter.string(from: Date())
        
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
                                        villager: $0.filter( { $0.birthday == today } ).first ?? $0.first!,
                                        villagerImage: nil,
                                        museumCollection: generateMuseumProgress())
                downloadImages(for: entry, completion: completion)
            })
    }

    private func downloadImages(for model: WidgetModel, completion: @escaping (Timeline<WidgetModel>) -> ()) {
        var model = model
        if let villager = model.villager, let url = URL(string: ACNHApiService.BASE_URL.absoluteString +
                            ACNHApiService.Endpoint.villagerIcon(id: villager.id).path()) {
            SDWebImageDownloader.shared.downloadImage(with: url) { (image, _, _, _) in
                model.villagerImage = image
                let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
                completion(Timeline(entries: [model], policy: .after(nextUpdateDate)))
            }
        }
    }
    
    private func generateMuseumProgress() -> [MuseumProgress] {
        var museumProgress: [MuseumProgress] = []
        let museumCategories: [Backend.Category] = [.fish, .bugs, .seaCreatures, .fossils, .art]
        for category in museumCategories {
            var total = 80
            if category == .seaCreatures {
                total = 40
            } else if category == .fossils {
                total = 73
            } else if category == .art {
                total = 43
            }
            museumProgress.append(MuseumProgress(category: category,
                                                 have: collection.itemsIn(useItems: false, category: category),
                                                 total: total))
        }
        return museumProgress
    }
    
    func getSnapshot(in context: Context, completion: @escaping (WidgetModel) -> Void) {
        let entry = WidgetModel(date: Date(),
                                villager: static_villager,
                                villagerImage: nil,
                                museumCollection: generateMuseumProgress())
        completion(entry)
    }

    func placeholder(in context: Context) -> WidgetModel {
        WidgetModel(date: Date(),
                    villager: nil,
                    villagerImage: nil,
                    museumCollection: [MuseumProgress(category: .fish, have: 0, total: 0),
                                       MuseumProgress(category: .bugs, have: 0, total: 0),
                                       MuseumProgress(category: .seaCreatures, have: 0, total: 0),
                                       MuseumProgress(category: .fossils, have: 0, total: 0),
                                       MuseumProgress(category: .art, have: 0, total: 0)])
    }
}
