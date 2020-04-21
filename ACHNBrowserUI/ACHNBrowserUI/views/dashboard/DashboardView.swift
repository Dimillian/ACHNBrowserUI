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
    enum Sheet: Identifiable {
        case safari(URL), settings
        
        var id: String {
            switch self {
            case .safari(let url):
                return url.absoluteString
            case .settings:
                return "settings"
            }
        }
    }
    
    
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject private var viewModel = DashboardViewModel()
    @ObservedObject private var villagersViewModel = VillagersViewModel()
    @State var selectedSheet: Sheet?
    
    func makeSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .settings:
            return AnyView(SettingsView())
        case .safari(let url):
            return AnyView(SafariView(url: url))
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                makeDateView()
                makeAvailableCritterSection()
                makeCritterCollectionProgressSection()
                if !villagersViewModel.todayBirthdays.isEmpty {
                    makeBirthdayView()
                }
                makeTopTurnipSection()
                makeRecentNookazonListings()
            }
            .listStyle(GroupedListStyle())
            .onAppear(perform: viewModel.fetchListings)
            .onAppear(perform: viewModel.fetchIsland)
            .onAppear(perform: villagersViewModel.fetch)
            .navigationBarItems(trailing: preferenceButton)
            .navigationBarTitle("Dashboard",
                                displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .sheet(item: $selectedSheet, content: makeSheet)
    }
}

extension DashboardView {
    private var preferenceButton: some View {
        Button(action: {
            self.selectedSheet = .settings
        }, label: {
            Image(systemName: "wrench").imageScale(.medium)
        })
    }

    func makeDateView() -> some View {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, dd MMMM"
        let dateString = formatter.string(from: Date())
        return Section(header: makeSectionHeader(icon: "icon-helmet", text: "Today")) {
            VStack(alignment: .leading) {
                Text(dateString)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.text)
                EventTextView()
            }
            .padding(.vertical, 5)
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
    
    private func makeSectionHeader(icon: String, text: String) -> some View {
        Group {
            HStack {
                Text(text).font(.headline)
            }
            .padding(8)
            .background(Color.dialogueReverse)
            .cornerRadius(20)
        }.padding(.leading, -8)
    }
    
    func makeAvailableCritterSection() -> some View {
        Section(header: makeSectionHeader(icon: "icon-insect", text: "Available This Month")) {
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
                .padding(.vertical, 5)
            }
        }
    }
    
    func makeCritterCollectionProgressSection() -> some View {
        Section(header: makeSectionHeader(icon: "icon-leaf", text: "Collection Progress")) {
            VStack(alignment: .leading) {
                if !viewModel.fishes.isEmpty &&
                    !viewModel.bugs.isEmpty &&
                    !viewModel.fossils.isEmpty {
                    HStack {
                        Image("Fish19")
                            .resizable()
                            .frame(width: 20, height: 20)
                        ProgressView(progress:
                            Float(caughtIn(list: viewModel.fishes)) / Float(viewModel.fishes.count))
                        Text("\(caughtIn(list: viewModel.fishes))/\(viewModel.fishes.count)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.text)
                    }
                    HStack {
                        Image("Ins62")
                            .resizable()
                            .frame(width: 20, height: 20)
                        ProgressView(progress:
                        Float(caughtIn(list: viewModel.bugs)) / Float(viewModel.bugs.count))
                        Text("\(caughtIn(list: viewModel.bugs))/\(viewModel.bugs.count)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.text)
                    }
                    HStack {
                        Image("icon-fossil")
                            .frame(width: 20, height: 20)
                        ProgressView(progress: Float(caughtIn(list: viewModel.fossils)) / Float(viewModel.fossils.count))
                        Text("\(caughtIn(list: viewModel.fossils))/\(viewModel.fossils.count)")
                            .font(.caption)
                            .bold()
                            .foregroundColor(.text)
                    }
                } else {
                    Text("Loading...")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, 10)
            .padding(.top, 5)
        }
        .accentColor(.grass)
    }
    
    func makeBirthdayView() -> some View {
        Section(header: makeSectionHeader(icon: "icon-present", text: "Villager birthday")) {
            ForEach(villagersViewModel.todayBirthdays) { villager in
                NavigationLink(destination: VillagerDetailView(villager: villager),
                               label: {
                                VillagerRowView(villager: villager)
                })
            }
        }
    }
    
    func makeTopTurnipSection() -> some View {
        Section(header: makeSectionHeader(icon: "icon-turnip", text: "Top Turnip Island")) {
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
        Section(header: makeSectionHeader(icon: "icon-bell", text: "Recent Nookazon Listings")) {
            if viewModel.recentListings == nil {
                Text("Loading...")
                    .foregroundColor(.secondary)
            }
            viewModel.recentListings.map { listings in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(listings) { listing in
                            Button(action: {
                                self.selectedSheet = .safari(URL.nookazon(listing: listing)!)
                            }) {
                                VStack {
                                    ItemImage(path: listing.img?.absoluteString, size: 80)
                                    Text(listing.name!)
                                        .font(.headline)
                                        .foregroundColor(.text)
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                                        .fill(Color.dialogue)
                                        .shadow(radius: 4)
                                )
                                .padding(.vertical, 10)
                            }
                        }
                    }
                    .padding()
                }
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
