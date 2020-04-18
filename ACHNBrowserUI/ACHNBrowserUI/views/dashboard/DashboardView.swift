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

struct Progress: UIViewRepresentable {
    func makeUIView(context: Context) -> UIProgressView {
        UIProgressView()
    }
    
    func updateUIView(_ uiView: UIProgressView, context: Context) {
        uiView.progress = 0.5
    }
}

class DashboardViewModel: ObservableObject {
    @Published var recentListings: [Listing]?
    @Published var island: Island?
    
    var listingCancellable: AnyCancellable?
    var islandCancellable: AnyCancellable?

    func fetchListings() {
        listingCancellable = NookazonService
            .recentListings()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] listings in
                self?.recentListings = listings
        }
    }
    
    func fetchIsland() {
        islandCancellable = TurnipExchangeService.shared
            .fetchIslands()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { _ in }) { [weak self] islands in
                self?.island = islands.first
        }
    }
}

struct DashboardView: View {
    @ObservedObject var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationView {
            List {
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
    }
}

extension DashboardView {
    func makeAvailableCritterSection() -> some View {
        Section(header: Text("Critters Active")) {
            HStack {
                Spacer()
                VStack {
                    Text("10/10")
                        .font(.largeTitle)
                        .bold()
                    Text("Fish")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Divider()
                Spacer()
                VStack {
                    Text("10/10")
                        .font(.largeTitle)
                        .bold()
                    Text("Bugs")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
        }
    }
    
    func makeCritterCollectionProgressSection() -> some View {
        Section(header: Text("Collection Progress")) {
            VStack(alignment: .leading) {
                Text("Fish")
                    .font(.subheadline)
                Progress()
                Text("Bugs")
                    .font(.subheadline)
                Progress()
                Text("Fossils")
                    .font(.subheadline)
                Progress()
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

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
