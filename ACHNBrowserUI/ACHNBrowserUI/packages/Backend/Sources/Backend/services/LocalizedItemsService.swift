//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 11/05/2020.
//

import Foundation

fileprivate struct LocalizedItem: Codable {
    struct ID: Codable, Equatable, Hashable {
        let decimal: Int
        
        init(from decoder: Decoder) throws {
            var container = try decoder.unkeyedContainer()
            decimal = try container.decode(Int.self)
        }
    }
    
    let name: String
    let id: ID
    let DiyRecipe: ID?
}

public struct LocalizedItemService {
    static let shared = LocalizedItemService()
    private static let filePrefix = "items_EU"

    private let currentLocale: Locale
    private var localizationItems: [Int: LocalizedItem] = [:]
    private var localizationDYI: [Int: LocalizedItem] = [:]
    
    init() {
        if let preferredIdentifier = Locale.preferredLanguages.first {
            self.currentLocale = Locale(identifier: preferredIdentifier)
        } else {
            self.currentLocale = Locale.current
        }
        let tables = loadCurrentLocalization()
        self.localizationItems = tables.0
        self.localizationDYI = tables.1
    }
    
    public func localizedNameFor(itemId: Int) -> String? {
        return localizationItems[itemId]?.name ?? localizationDYI[itemId]?.name
    }
    
    private func loadCurrentLocalization() -> ([Int: LocalizedItem], [Int: LocalizedItem]) {
        let decoder = JSONDecoder()
        guard let landuageCode = currentLocale.languageCode,
            let url = Bundle.main.url(forResource: Self.filePrefix + landuageCode, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let object = try? decoder.decode([String: [LocalizedItem]].self, from: data)
            else {
                return ([:],[:])
        }
        let items = object.compactMap{ $0.value }.flatMap{ $0 }
        return (
            Dictionary(uniqueKeysWithValues: items.map { ($0.id.decimal, $0) }),
            Dictionary(uniqueKeysWithValues: items.filter { $0.DiyRecipe != nil }
                .map { ($0.DiyRecipe!.decimal, $0) })
            )
    }
}
