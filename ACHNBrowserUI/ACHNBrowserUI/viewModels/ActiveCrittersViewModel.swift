//
//  ActiveCrittersViewModel.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 01/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import Foundation
import Combine
import SwiftUI
import Backend

class ActiveCrittersViewModel: ObservableObject {
    
    @Published var activeFish: [Item] = []
    @Published var activeBugs: [Item] = []
    @Published var newFishThisMonth: [Item] = []
    @Published var newBugsThisMonth: [Item] = []
    @Published var leavingFishThisMonth: [Item] = []
    @Published var leavingBugsThisMonth: [Item] = []
    
    @Published var caughFish: [Item] = []
    @Published var caughBugs: [Item] = []
    @Published var toCatchFish: [Item] = []
    @Published var toCatchBugs: [Item] = []
    
    @ObservedObject private var items: Items
    @ObservedObject private var collection: UserCollection
    
    private var cancellable: AnyCancellable?
    
    init(filterOutInCollection: Bool = false, items: Items = .shared, collection: UserCollection = .shared) {
        self.items = items
        self.collection = collection
        
        cancellable = Publishers.CombineLatest(items.$categories, collection.$critters)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] (items, critters) in
                self?.activeFish = items[.fish]?.filterActive() ?? []
                self?.activeBugs = items[.bugs]?.filterActive() ?? []
                self?.newFishThisMonth = self?.activeFish.filter{ $0.isNewThisMonth() } ?? []
                self?.newBugsThisMonth = self?.activeBugs.filter{ $0.isNewThisMonth() } ?? []
                self?.leavingFishThisMonth = self?.activeFish.filter{ $0.leavingThisMonth() } ?? []
                self?.leavingBugsThisMonth = self?.activeBugs.filter{ $0.leavingThisMonth() } ?? []
                
                self?.caughFish = critters.filterActive().filter{ $0.appCategory == .fish}
                self?.caughBugs = critters.filterActive().filter{ $0.appCategory == .bugs}
                
                self?.toCatchFish = self?.activeFish.filter{ !critters.contains($0) } ?? []
                self?.toCatchBugs = self?.activeBugs.filter{ !critters.contains($0) } ?? []
                
                if filterOutInCollection {
                    self?.newBugsThisMonth = self?.newBugsThisMonth.filter{ !critters.contains($0) } ?? []
                    self?.newFishThisMonth = self?.newFishThisMonth.filter{ !critters.contains($0) } ?? []
                    
                    self?.leavingBugsThisMonth = self?.leavingBugsThisMonth.filter{ !critters.contains($0) } ?? []
                    self?.leavingFishThisMonth = self?.leavingFishThisMonth.filter{ !critters.contains($0) } ?? []
                    
                    self?.activeBugs = self?.activeBugs.filter{ !critters.contains($0) } ?? []
                    self?.activeFish = self?.activeFish.filter{ !critters.contains($0) } ?? []
                }
        }
    }
}
