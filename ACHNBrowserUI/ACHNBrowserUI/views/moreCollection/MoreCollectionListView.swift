//
//  MoreView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 27.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct MoreCollectionListView: View {

    // MARK: - Properties

    @EnvironmentObject private var collection: UserCollection

    let viewModel: MoreCollectionListViewModel

    // MARK: - Life cycle

    init(viewModel: MoreCollectionListViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        ForEach(viewModel.rows, id: \.self) { row in
            self.makeListRow(row: row)
        }
    }

    // MARK: - Private

    private func makeListRow(row: MoreCollectionListViewModel.Row) -> some View {
        switch row {
        case .critters:
            return NavigationLink(destination: CrittersListView()) {
                Text(row.description)
            }.eraseToAnyView()

        case .designs:
            return NavigationLink(destination: DesignListView()) {
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
            MoreCollectionListView(viewModel: MoreCollectionListViewModel())
        }
        .previewLayout(.sizeThatFits)
    }
}
#endif
