//
//  VillagersSortView.swift
//  ACHNBrowserUI
//
//  Created by Ricardo Hochman on 25/05/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct VillagersSortView: View {
    
    @State private var showSortSheet = false
    @Binding var sort: VillagersViewModel.Sort?
    
    enum Sort: String, CaseIterable {
        case name, species
    }

    private var sortButton: some View {
        Button(action: {
            self.showSortSheet.toggle()
        }) {
            Image(systemName: sort == nil ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                .imageScale(.large)
        }
        .safeHoverEffectBarItem(position: .trailing)
    }

    private var sortSheet: ActionSheet {
        var buttons: [ActionSheet.Button] = []
        for sort in VillagersViewModel.Sort.allCases {
            buttons.append(.default(Text(LocalizedStringKey(sort.rawValue.localizedCapitalized)),
                                    action: {
                                        self.sort = sort
            }))
        }
        
        if sort != nil {
            buttons.append(.default(Text("Clear Selection"), action: {
                self.sort = nil
            }))
        }
        
        buttons.append(.cancel())
        
        let title = Text("Sort villagers")
        
        if let currentSort = sort {
            let currentSortName = NSLocalizedString(currentSort.rawValue.localizedCapitalized, comment: "")
            return ActionSheet(title: title,
                               message: Text("Current Sort: \(currentSortName)"),
                               buttons: buttons)
        }
        
        return ActionSheet(title: title, buttons: buttons)
    }
    
    var body: some View {
        sortButton
            .actionSheet(isPresented: $showSortSheet, content: { self.sortSheet })
    }
}
