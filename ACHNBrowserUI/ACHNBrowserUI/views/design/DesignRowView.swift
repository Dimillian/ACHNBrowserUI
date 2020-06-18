//
//  DesignListView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 24.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct DesignRowView: View {

    // MARK: - Properties

    private let viewModel: DesignRowViewModel
    private let id = UUID()

    // MARK: - Life cycle

    init(viewModel: DesignRowViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Public

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.title.capitalized)
                    .style(appStyle: .rowTitle)

                Text(viewModel.code)
                    .fontWeight(.semibold)
                    .font(Font.subheadline.monospacedDigit())

                if !viewModel.description.isEmpty {
                    Text(viewModel.description.capitalized)
                        .style(appStyle: .rowDescription)
                }
            }

            Spacer()

            Text(viewModel.category)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.acHeaderBackground)
                .lineLimit(1)
        }
        .foregroundColor(.acSecondaryText)
    }
}

// MARK: - Preview

#if DEBUG
struct DesignRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DesignRowView(viewModel:
                    DesignRowViewModel(design: Design(title: "Jedi", code: "MOPJ15LTDSXC4T", description: "Jedi Tunic")))

                DesignRowView(viewModel:
                    DesignRowViewModel(design: Design(title: "Sam",
                                                      code: "MA667931515180",
                                                      description: "Sokola Island. Might have more StarWars designs"))
                )
            }
        }
    }
}
#endif
