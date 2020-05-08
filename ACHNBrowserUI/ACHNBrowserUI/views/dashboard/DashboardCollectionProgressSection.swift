//
//  DashboardCollectionProgressSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 23/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct DashboardCollectionProgressSection: View {
    @EnvironmentObject private var collection: UserCollection
    @ObservedObject var viewModel: DashboardViewModel
    
    
    private func makeProgressView(icon: String, critters: [Item]) -> some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
            ProgressView(progress: CGFloat(collection.caughtIn(list: critters)) / CGFloat(critters.count),
                         trackColor: .catalogUnselected,
                         progressColor: .grass)
            Text("\(collection.caughtIn(list: critters))/\(critters.count)")
                .font(.caption)
                .bold()
                .foregroundColor(.text)
        }
    }
    
    private func makeArtProgressView(icon: String, art: [Item]) -> some View {
        HStack {
            Image(icon)
                .resizable()
                .frame(width: 20, height: 20)
            ProgressView(progress: CGFloat(collection.collectedIn(list: art)) / CGFloat(art.count),
                         trackColor: .catalogUnselected,
                         progressColor: .grass)
            Text("\(collection.collectedIn(list: art))/\(art.count)")
                .font(.caption)
                .bold()
                .foregroundColor(.text)
        }
    }
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Collection Progress")) {
            VStack(alignment: .leading) {
                if !viewModel.fishes.isEmpty &&
                    !viewModel.bugs.isEmpty &&
                    !viewModel.fossils.isEmpty &&
                    !viewModel.art.isEmpty {
                    makeProgressView(icon: "Fish19", critters: viewModel.fishes)
                    makeProgressView(icon: "Ins62", critters: viewModel.bugs)
                    makeProgressView(icon: "icon-fossil", critters: viewModel.fossils)
                    makeArtProgressView(icon: "icon-leaf", art: viewModel.art)
                } else {
                    Text("Loading...")
                        .foregroundColor(.secondary)
                }
            }
            .padding(.vertical, 10)
        }
        .accentColor(.grass)
    }
}

struct DashboardCollectionProgressVIew_Previews: PreviewProvider {
    static var previews: some View {
        DashboardCollectionProgressSection(viewModel: DashboardViewModel())
    }
}
