//
//  DashboardViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import Backend

class DashboardViewModel: ObservableObject {
    @Published var recentListings: [Listing]?
    @Published var island: Island?
    @Published var sectionOrder: [TodaySection]
    
    public var selection = Set<String>()
    private var listingCancellable: AnyCancellable?
    private var islandCancellable: AnyCancellable?
    
    init() {
        self.sectionOrder = AppUserDefaults.shared.todaySectionList
        loadSectionList()
    }

    public func saveSectionList() {
        for index in 0..<sectionOrder.count {
            let name = sectionOrder[index].name
            if !selection.contains(name) && name != TodaySection.nameSubscribe {
                sectionOrder[index].enabled = false
            } else {
                sectionOrder[index].enabled = true
            }
        }
        AppUserDefaults.shared.todaySectionList = sectionOrder
    }

    private func loadSectionList() {
        // If new items were added since the last update, append them to the list
        TodaySection.defaultSectionList.forEach { (section) in
            if !sectionOrder.contains(section) {
                sectionOrder.append(TodaySection(name: section.name, enabled: true))
            }
        }
        sectionOrder.forEach { (section) in
            if section.enabled {
                selection.insert(section.name)
            }
        }
    }
        
    func fetchListings() {
        listingCancellable = NookazonService
            .recentListings()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] listings in
                self?.recentListings = listings
        }
    }
    
    private func fetchIsland() {
        /*
        islandCancellable = TurnipExchangeService.shared
            .fetchIslands()
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] islands in
                self?.island = islands.first
            })
        */
    }
}
