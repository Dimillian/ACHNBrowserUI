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
    
    public var selection = Set<TodaySection.Name>()
    private var listingCancellable: AnyCancellable?
    private var islandCancellable: AnyCancellable?
    
    init() {
        self.sectionOrder = AppUserDefaults.shared.todaySectionList
        loadSectionList()
    }

    public func saveSectionList() {
        for (index, section) in sectionOrder.enumerated() {
            if !selection.contains(section.name) && section.name != .subscribe {
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
        // If item were removed since the last update, remove from the list
        sectionOrder.forEach { (section) in
            if !TodaySection.defaultSectionList.contains(section),
                let obsoletSectionIndex = sectionOrder.firstIndex(of: section) {
                sectionOrder.remove(at: obsoletSectionIndex)
            }
        }
        selection = Set(sectionOrder.filter(\.enabled).map(\.name))
    }
    
    public func resetSectionList() {
        sectionOrder = TodaySection.defaultSectionList
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
