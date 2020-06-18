//
//  MoreView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 27.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct CollectionMoreDetailView: View {

    // MARK: - Properties

    @EnvironmentObject private var collection: UserCollection

    let viewModel: CollectionMoreDetailViewModel

    // MARK: - Life cycle

    init(viewModel: CollectionMoreDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        ForEach(viewModel.rows, id: \.self) { row in
            self.makeRowView(for: row)
        }
    }

    // MARK: - Private

    private func makeRowView(for row: CollectionMoreDetailViewModel.Row) -> some View {
        switch row {
        case .critters:
            return NavigationLink(destination: CrittersListView()) {
                Text(row.description)
            }.eraseToAnyView()

        case .designs:
            return NavigationLink(destination: DesignListView()) {
                Text(row.description)
            }.eraseToAnyView()
        case .dodoCodes:
            return NavigationLink(destination: DodoCodeListView()) {
                Text(row.description)
            }.eraseToAnyView()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            CollectionMoreDetailView(viewModel: CollectionMoreDetailViewModel())
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
