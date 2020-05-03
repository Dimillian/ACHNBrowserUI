//
//  DashboardCollectionProgressSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 23/04/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

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
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Collection Progress")) {
            VStack(alignment: .leading) {
                if !viewModel.fishes.isEmpty &&
                    !viewModel.bugs.isEmpty &&
                    !viewModel.fossils.isEmpty {
                    makeProgressView(icon: "Fish19", critters: viewModel.fishes)
                    makeProgressView(icon: "Ins62", critters: viewModel.bugs)
                    makeProgressView(icon: "icon-fossil", critters: viewModel.fossils)
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
}

struct DashboardCollectionProgressVIew_Previews: PreviewProvider {
    static var previews: some View {
        DashboardCollectionProgressSection(viewModel: DashboardViewModel())
    }
}
