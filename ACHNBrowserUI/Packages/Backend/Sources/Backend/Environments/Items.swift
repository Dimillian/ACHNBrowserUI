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
import os.log

public class Items: ObservableObject {
    public static let shared = Items()
    
    // MARK: - Vars
    @Published public var categories: [Category: [Item]] = [:]
    @Published public var villagersHouse: [String: VillagerHouse] = [:]
    @Published public var villagersLike: [String: VillagerLike] = [:]
    
    private var villagersHouseCache: [String: [Item]] = [:]
    private var villagersLikeCache: [String: [Item]] = [:]
    
    private let spotlightIndex: [Category] = [.fish, .bugs, .fossils, .art, .seaCreatures]
    private let spotlightQueue = DispatchQueue(label: "com.achelper.spotlight.quueue", qos: .background)
    private let itemsQueue = DispatchQueue(label: "com.achelper.items.queue",
                                           qos: .userInitiated)
        
    private let itemLogHandler = OSLog(subsystem: "com.achelper.items", category: "ac-perf")
    private let itemProgressHandler = OSLog(subsystem: "com.achelper.items", category: .pointsOfInterest)
    
    // MARK: - Internals
    init() {
        
        os_signpost(.begin, log: itemLogHandler, name: "Processing Items", "Begin processing items")
        
        var shouldIndex = false
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, AppUserDefaults.shared.spotlightIndexVersion != version {
            AppUserDefaults.shared.spotlightIndexVersion = version
            shouldIndex = true
        }
        
        var processedCategories = 0
        
        for category in Category.allCases {
            // Migrated to new JSON format
            if let filename = Category.dataFilename(category: category) {
                _ = ItemsAPI
                    .fetchFile(name: filename)
                    .replaceError(with: NewItemResponse(total: 0, results: []))
                    .eraseToAnyPublisher()
                    .map{ $0.results.filter{ $0.content.appCategory == category } }
                    .subscribe(on: itemsQueue)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] items in
                        processedCategories += 1
                        self?.processNewCategoryJSON(category: category,
                                                     items: items,
                                                     processedCategories: processedCategories,
                                                     index: shouldIndex)
                }
            } else {
                // Old JSON format
                _ = ItemsAPI
                    .fetch(endpoint: category)
                    .replaceError(with: ItemResponse(total: 0, results: []))
                    .eraseToAnyPublisher()
                    .map{ $0.results }
                    .subscribe(on: itemsQueue)
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] items in
                        processedCategories += 1
                        self?.processOldCategoryJSON(category: category,
                                                     items: items,
                                                     processedCategories: processedCategories,
                                                     index: shouldIndex)
                }
            }
        }
        _ = ItemsAPI
            .fetchVillagerHouse()
            .replaceError(with: [])
            .eraseToAnyPublisher()
            .map{ Dictionary(uniqueKeysWithValues: $0.map{ ($0.id, $0) }) }
            .subscribe(on: itemsQueue)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in self?.villagersHouse = items })
        
        _ = ItemsAPI
            .fetchVillagerLikes()
            .replaceError(with: [:])
            .eraseToAnyPublisher()
            .subscribe(on: itemsQueue)
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] items in self?.villagersLike = items })
    }
    
    private func processNewCategoryJSON(category: Category,
                                        items: [NewItemResponse.ItemWrapper],
                                        processedCategories: Int,
                                        index: Bool) {
        var items = items
        for (index, item) in items.enumerated() where item.variations?.isEmpty == false {
            items[index].content.variations = item.variations
        }
        let finalItems = items.map{ $0.content }
        categories[category] = finalItems
        if spotlightIndex.contains(category) == true, index {
            indexItems(category: category, items: finalItems)
        }
        os_signpost(.event, log: itemProgressHandler,
                    name: "Processing Items", "Processed categories %{public}s with items %{public}d", category.rawValue, items.count)
        
        checkEndProcessing(done: processedCategories)
    }
    
    private func processOldCategoryJSON(category: Category,
                                        items: [Item],
                                        processedCategories: Int,
                                        index: Bool) {
        categories[category] = items
        if spotlightIndex.contains(category) == true, index {
            indexItems(category: category, items: items)
        }
        os_signpost(.event, log: itemProgressHandler,
                    name: "Processing Items", "Processed categories %{public}s with items %{public}d", category.rawValue, items.count)
        
        checkEndProcessing(done: processedCategories)
    }
    
    
    private func checkEndProcessing(done: Int) {
        if done == Category.allCases.count {
            os_signpost(.end,
                        log: itemLogHandler,
                        name: "Processing Items",
                        "Done all processing items categories %{public}d",
                        done)
        }
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
    
    // MARK: - Public API
    public func itemsCount(for categories: [Backend.Category]) -> Int {
        os_signpost(.begin,
                    log: itemLogHandler,
                    name: "Counting items", "Begin counting item for categories %{public}d",
                    categories.count)
        
        var count = 0
        for (_, value) in self.categories.enumerated() {
            if categories.contains(value.key) {
                count += value.value.count
            }
        }
        
        os_signpost(.end,
                    log: itemLogHandler,
                    name: "Counting items", "Done counting item for categories %{public}d",
                    categories.count)
        
        return count
    }
    
    public func matchVillagerItems(villager: String) -> AnyPublisher<[Item]?, Never> {
        if let cached = villagersHouseCache[villager] {
            return Just(cached).eraseToAnyPublisher()
        }
        if let villagerHouse = villagersHouse[villager] {
            return Deferred {
                Future { [weak self] resolve in
                    guard let self = self else { return }
                    
                    os_signpost(.begin,
                                log: self.itemLogHandler,
                                name: "Matching villagers items",
                                "Begin to match villagers items")
                    
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
                    
                    os_signpost(.event,
                                log: self.itemProgressHandler,
                                name: "Matching villagers items",
                                "Found %{public}d items in categories", items.count)
                    
                    var results: [Item] = []
                    for item in villagerItems {
                        if let match = items.first(where: { $0.name.lowercased() == item.name.lowercased() }) {
                            results.append(match)
                        }
                    }
                    results = Array(Set(results))
                    
                    os_signpost(.event,
                                log: self.itemProgressHandler,
                                name: "Matching villagers items",
                                "Converted matched items to set")
                    
                    self.villagersHouseCache[villager] = results
                    
                    os_signpost(.end,
                                log: self.itemLogHandler,
                                name: "Matching villagers items",
                                "Done matching villagers items for %{public}s items %{public}d",
                                villager, results.count)
                    
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
                    guard let self = self else {
                        return resolve(.success([]))
                    }
                    
                    var results: [Item] = []
                    for (_, dic) in self.categories.enumerated() where categories.contains(dic.key) {
                        let items = dic.value
                            .filter{ $0.colors?.isEmpty == false && $0.styles?.isEmpty == false }
                        for item in items {
                            var item = item
                            var colorsMatch = item.colors!.filter{ likes.contains($0.lowercased()) }
                            if colorsMatch.count == 0 {
                                if let variant = item.variations?
                                    .first(where: { $0.content.colors?
                                        .filter{ likes.contains($0.lowercased()) }.count ?? 0 >= 1 }) {
                                    colorsMatch.append("match")
                                    item.preferedVariantImage = variant.content.image
                                }
                            }
                            let styleMatch = item.styles!.filter{ likes.contains($0.lowercased()) }
                            if colorsMatch.count >= 1 && styleMatch.count >= 1 {
                                results.append(item)
                            }
                        }
                    }
                    objc_sync_enter(self.villagersLikeCache)
                    self.villagersLikeCache[villager] = results
                    objc_sync_exit(self.villagersLikeCache)
                    return resolve(.success(results))
                }
            }.eraseToAnyPublisher()
        }
        return Just(nil).eraseToAnyPublisher()
    }
}
