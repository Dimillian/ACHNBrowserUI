//
//  VillagersSortView.swift
//  ACHNBrowserUI
//
//  Created by Ricardo Hochman on 25/05/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct VillagersSortView: View {
    @Binding var sort: VillagersViewModel.Sort?
    
    enum Sort: String, CaseIterable {
        case name, species
    }

    private var sortMenu: some View {
        Menu {
            ForEach(VillagersViewModel.Sort.allCases, id: \.self) { sort in
                Button(LocalizedStringKey(sort.rawValue.localizedCapitalized), action: {
                    self.sort = sort
                })
            }
            if sort != nil {
                Divider()
                Button("Clear Selection", action: {
                    self.sort = nil
                })
            }
        } label: {
            Image(systemName: sort == nil ? "arrow.up.arrow.down.circle" : "arrow.up.arrow.down.circle.fill")
                .imageScale(.large)
        }
    }
    
    var body: some View {
        sortMenu
    }
}
