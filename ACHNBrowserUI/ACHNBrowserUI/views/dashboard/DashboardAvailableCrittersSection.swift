//
//  DashboardAvailableCrittersSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 23/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct DashboardAvailableCrittersSection: View {
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject var viewModel: DashboardViewModel
    
    private var numberOfBugs: String {
        if !viewModel.bugs.isEmpty {
            return "\(collection.caughtIn(list: viewModel.bugs))/\(viewModel.bugs.filterActive().count)"
        }
        return "Loading..."
    }
    
    private var numberOfFish: String {
        if !viewModel.fishes.isEmpty {
            return "\(collection.caughtIn(list: viewModel.fishes))/\(viewModel.fishes.filterActive().count)"
        }
        return "Loading..."
    }
    
    private var newFishes: Int {
        viewModel.fishes.filterActive().filter{ $0.isNewThisMonth() }.count
    }
    
    private var newBugs: Int {
        viewModel.bugs.filterActive().filter{ $0.isNewThisMonth() }.count
    }
    
    private var crittersView: some View {
        HStack {
            Spacer()
            VStack {
                Text(numberOfFish).style(appStyle: .title)
                Text("\(newFishes) new fishes")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            Spacer()
            Divider()
            Spacer()
            VStack {
                Text(numberOfBugs).style(appStyle: .title)
                Text("\(newBugs) new bugs")
                    .font(.caption)
                    .foregroundColor(.secondaryText)
            }
            Spacer()
        }
        .padding(.vertical, 5)
    }
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Available This Month")) {
            NavigationLink(destination: ActiveCrittersView(activeFishes: viewModel.fishes.filterActive(),
                                                           activeBugs: viewModel.bugs.filterActive())) {
                                                            crittersView
            }
        }
    }
}

struct DashboardCrittersView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardAvailableCrittersSection(viewModel: DashboardViewModel())
    }
}
