//
//  DashboardView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/18/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

struct DashboardView: View {
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject private var viewModel = DashboardViewModel()
    @State var selectedURL: URL?
    
    var body: some View {
        NavigationView {
            List {
                makeDateView()
                makeAvailableCritterSection()
                makeCritterCollectionProgressSection()
                makeTopTurnipSection()
                makeRecentNookazonListings()
            }
            .listStyle(GroupedListStyle())
            .onAppear(perform: viewModel.fetchListings)
            .onAppear(perform: viewModel.fetchIsland)
            .navigationBarTitle("Dashboard",
                                displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $selectedURL) {
            SafariView(url: $0)
        }
    }
}

extension DashboardView {
    func makeDateView() -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM"
        let dateString = formatter.string(from: Date())
        return Section(header: Text("Today")) {
            Text(dateString)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.text)
        }
    }
    
    private var numberOfBugs: String {
        if !viewModel.bugs.isEmpty {
            return "\(caughtIn(list: viewModel.bugs))/\(viewModel.bugs.filterActive().count)"
        }
        return "Loading..."
    }
    
    private var numberOfFish: String {
        if !viewModel.fishes.isEmpty {
            return "\(caughtIn(list: viewModel.fishes))/\(viewModel.fishes.filterActive().count)"
        }
        return "Loading..."
    }
    
    private func caughtIn(list: [Item]) -> Int {
        var caught = 0
        for critter in collection.critters {
            if list.contains(critter) {
                caught += 1
            }
        }
        return caught
    }
    
    private var numberOfFossils: String {
        if !viewModel.fossils.isEmpty {
            return "\(caughtIn(list: viewModel.fossils))/\(viewModel.fossils.count)"
        }
        return "Loading..."
    }
    
    func makeAvailableCritterSection() -> some View {
        Section(header: Text("Available This Month")) {
            NavigationLink(destination: ActiveCrittersView(activeFishes: viewModel.fishes.filterActive(),
                                                           activeBugs: viewModel.bugs.filterActive())) {
                HStack {
                    Spacer()
                    VStack {
                        Text(numberOfFish)
                            .font(.title)
                            .bold()
                            .foregroundColor(.text)
                        Text("Fishes")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }
                    Spacer()
                    Divider()
                    Spacer()
                    VStack {
                        Text(numberOfBugs)
                            .font(.title)
                            .bold()
                            .foregroundColor(.text)
                        Text("Bugs")
                            .font(.caption)
                            .foregroundColor(.secondaryText)
                    }
                    Spacer()
                }
            }
        }
    }
    
    func makeCritterCollectionProgressSection() -> some View {
        Section(header: Text("Collection Progress")) {
            VStack(alignment: .leading) {
                if !viewModel.fishes.isEmpty &&
                    !viewModel.bugs.isEmpty &&
                    !viewModel.fossils.isEmpty {
                    Text("Fishes")
                        .font(.subheadline)
                    ProgressView(progress:
                        Float(caughtIn(list: viewModel.fishes)) / Float(viewModel.fishes.filterActive().count))
                    Text("Bugs")
                        .font(.subheadline)
                    ProgressView(progress:
                        Float(caughtIn(list: viewModel.bugs)) / Float(viewModel.bugs.filterActive().count))
                    Text("Fossils")
                        .font(.subheadline)
                    ProgressView(progress: Float(caughtIn(list: viewModel.fossils)) / Float(viewModel.fossils.count))
                } else {
                    Text("Loading...")
                }
            }
            .padding(.bottom, 10)
            .padding(.top, 5)
        }
        .accentColor(.grass)
    }
    
    func makeTopTurnipSection() -> some View {
        Section(header: Text("Top Turnip Island")) {
            if viewModel.island == nil {
                Text("Loading...")
                    .foregroundColor(.secondary)
            }
            viewModel.island.map {
                TurnipCell(island: $0)
            }
        }
    }
    
    func makeRecentNookazonListings() -> some View {
        Section(header: Text("Recent Nookazon Listings")) {
            if viewModel.recentListings == nil {
                Text("Loading...")
                    .foregroundColor(.secondary)
            }
            viewModel.recentListings.map {
                ForEach($0) { listing in
                    Button(action: {
                        self.selectedURL = URL.nookazon(listing: listing)
                    }) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                ItemImage(path: listing.img?.absoluteString, size: 25)
                                    .frame(width: 25, height: 25)
                                Text(listing.name!)
                                    .font(.headline)
                                    .foregroundColor(.text)
                            }
                            ListingRow(listing: listing)
                        }
                    }
                }
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
