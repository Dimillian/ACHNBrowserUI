//
//  Items.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import CoreSpotlight
import SDWebImage

public class Items: ObservableObject {
    public static let shared = Items()
    
    @Published public var categories: [Category: [Item]] = [:]
    @Published public var villagersHouse: [String: VillagerHouse] = [:]
    @Published public var villagersLike: [String: VillagerLike] = [:]
    
    private var villagersHouseCache: [String: [Item]] = [:]
    private var villagersLikeCache: [String: [Item]] = [:]
    
    private let spotlightIndex: [Category] = [.fish, .bugs, .fossils, .art]
    private let spotlightQueue = DispatchQueue(label: "ac.spotlight", qos: .background)
    
    init() {
        var shouldIndex = false
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, AppUserDefaults.shared.spotlightIndexVersion != version {
            AppUserDefaults.shared.spotlightIndexVersion = version
            shouldIndex = true
        }
        
        for category in Category.allCases {
            // Migrated to new JSON format
            if let filename = Category.dataFilename(category: category) {
                _ = ItemsAPI
                    .fetchFile(name: filename)
                    .replaceError(with: NewItemResponse(total: 0, results: []))
                    .eraseToAnyPublisher()
                    .map{ $0.results.filter{ $0.content.appCategory == category } }
                    .subscribe(on: DispatchQueue.global())
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] items in
                        var items = items
                        for (index, item) in items.enumerated() where item.variations?.isEmpty == false {
                            items[index].content.variations = item.variations
                        }
                        let finalItems = items.map{ $0.content }
                        self?.categories[category] = finalItems
                        if self?.spotlightIndex.contains(category) == true, shouldIndex {
                            self?.indexItems(category: category, items: finalItems)
                        }
                        
                }
            } else {
                // Old JSON format
                _ = ItemsAPI
                    .fetch(endpoint: category)
                    .replaceError(with: ItemResponse(total: 0, results: []))
                    .eraseToAnyPublisher()
                    .map{ $0.results }
                    .subscribe(on: DispatchQueue.global())
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] items in
                        self?.categories[category] = items
                        if self?.spotlightIndex.contains(category) == true, shouldIndex {
                            self?.indexItems(category: category, items: items)
                        }
                }
            }
        }
        _ = ItemsAPI
            .fetchVillagerHouse()
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .map{ Dictionary(uniqueKeysWithValues: $0.map{ ($0.id, $0) }) }
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in self?.villagersHouse = items })
        
        _ = ItemsAPI
            .fetchVillagerLikes()
            .replaceError(with: [:])
            .eraseToAnyPublisher()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in self?.villagersLike = items })
    }
    
    public func itemsCount(for categories: [Backend.Category]) -> Int {
        var count = 0
        for (_, value) in self.categories.enumerated() {
            if categories.contains(value.key) {
                count += value.value.count
            }
        }
        return count
    }
    
    public func matchVillagerItems(villager: String) -> AnyPublisher<[Item]?, Never> {
        if let cached = villagersHouseCache[villager] {
            return Just(cached).eraseToAnyPublisher()
        }
        if let villagerHouse = villagersHouse[villager] {
            return Deferred {
                Future { [weak self] resolve in
                    var villagerItems: [VillagerHouse.Item] = []
                    if let items = villagerHouse.items {
                        villagerItems.append(contentsOf: items)
                    }
                    if let floor = villagerHouse.floor {
                        villagerItems.append(floor)
                    }
                    if let wallpaper = villagerHouse.wallaper {
                        villagerItems.append(wallpaper)
                    }
                    if let music = villagerHouse.music {
                        villagerItems.append(music)
                    }
                    
                    let items = Items.shared.categories
                        .mapValues({ $0 })
                        .filter { !$0.value.isEmpty && Category.villagerFurnitures().contains($0.key) }
                        .compactMap{ $1 }
                        .flatMap{ Array(Set($0)) }
                    var results: [Item] = []
                    for item in villagerItems {
                        if let match = items.first(where: { $0.name.lowercased() == item.name.lowercased() }) {
                            results.append(match)
                        }
                    }
                    results = Array(Set(results))
                    self?.villagersHouseCache[villager] = results
                    return resolve(.success(results))
                }
            }.eraseToAnyPublisher()
        }
        
        return Just(nil).eraseToAnyPublisher()
    }
    
    public func matchItemRecipe(item: Item) -> Item? {
        return categories[.recipes]?.first(where: { $0.name == item.name })
    }
    
    public func matchFinalItem(recipe: Item) -> Item? {
        if let stringCategory = recipe.itemCategory {
            let category = Category(itemCategory: stringCategory)
            return categories[category]?.first(where: { $0.name == recipe.name })
        }
        return nil
    }
    
    public func matchVillagerPreferredGifts(villager: String) -> AnyPublisher<[Item]?, Never> {
        if let cached = villagersLikeCache[villager] {
            return Just(cached).eraseToAnyPublisher()
        }
        if let likes = villagersLike.values.first(where: { $0.id == villager })?.likes {
            return Deferred {
                Future { [weak self] resolve in
                    let categories = Category.villagersGifts()
                    guard let weakself = self else {
                        return resolve(.success([]))
                    }
                    
                    var results: [Item] = []
                    for (_, dic) in weakself.categories.enumerated() where categories.contains(dic.key) {
                        let items = dic.value
                            .filter{ $0.colors?.isEmpty == false && $0.styles?.isEmpty == false }
                        for item in items {
                            let colorsMatch = item.colors!.filter{ likes.contains($0.lowercased()) }
                            let styleMatch = item.styles!.filter{ likes.contains($0.lowercased()) }
                            if colorsMatch.count >= 1 && styleMatch.count >= 1 {
                                results.append(item)
                            }
                        }
                    }
                    self?.villagersLikeCache[villager] = results
                    return resolve(.success(results))
                }
            }.eraseToAnyPublisher()
        }
        return Just(nil).eraseToAnyPublisher()
    }
    
    private func indexItems(category: Category, items: [Item]) {
        self.spotlightQueue.async {
            for item in items {
                if let image = item.finalImage {
                    let set = CSSearchableItemAttributeSet(itemContentType: "Text")
                    set.title = item.localizedName
                    set.identifier = "\(item.category)#\(item.name)"
                    set.contentDescription = "\(NSLocalizedString(category.rawValue, comment: ""))\n\(NSLocalizedString(item.obtainedFrom ?? item.obtainedFromNew?.first ?? "", comment: ""))\n\(item.formattedTimes() ?? "")"
                    SDWebImageDownloader.shared.downloadImage(with:  ImageService.computeUrl(key: image))
                    { (_, data, _, _) in
                        if let data = data {
                            set.thumbnailData = data
                            let item = CSSearchableItem(uniqueIdentifier: "\(item.category)#\(item.name)",
                                domainIdentifier: category.rawValue,
                                attributeSet: set)
                            CSSearchableIndex.default().indexSearchableItems([item], completionHandler: nil)
                        }
                    }
                }
            }
        }
    }
}
