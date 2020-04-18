//
//  IslandDetailView.swift
//  ACHNBrowserUI
//
//  Created by Eric Lewis on 4/18/20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct IslandDetailView: View {
    @ObservedObject var viewModel = IslandDetailViewModel()
    @State var showSafari = false
    
    var island: Island
    
    var body: some View {
        List {
            HStack {
                Spacer()
                Button("Join Island") {
                    self.showSafari.toggle()
                }
                .accentColor(.grass)
                Spacer()
            }
            Section(header: Text("Island")) {
                TurnipCell(island: island)
            }
            island.description.map { description in
                Section(header: Text("Description")) {
                    Text(description)
                }
            }
            Section(header: Text("Visitors")) {
                if viewModel.container == nil {
                    Text("Loading Visitors....")
                        .foregroundColor(.secondary)
                }
                viewModel.container.map {
                    ForEach($0.visitors) {
                        Text($0.name)
                    }
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(island.name)
        .onAppear {
            self.viewModel.fetch(turnipCode: self.island.turnipCode)
        }
        .sheet(isPresented: $showSafari) {
            SafariView(url: URL(string: "https://turnip.exchange/island/\(self.island.turnipCode)")!)
                .edgesIgnoringSafeArea(.all)
        }
    }
}
