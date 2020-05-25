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

    let designRowViewModel: DesignRowViewModel

    // MARK: - Life cycle

    init(designRowViewModel: DesignRowViewModel) {
        self.designRowViewModel = designRowViewModel
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(designRowViewModel.title.capitalized)
                    .style(appStyle: .rowTitle)

                Text(designRowViewModel.code)
                    .fontWeight(.semibold)
                    .font(.subheadline)

                if !designRowViewModel.description.isEmpty {
                    Text(designRowViewModel.description.capitalized)
                        .style(appStyle: .rowDescription)
                }
            }

            Spacer()

            Text(designRowViewModel.category)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.acHeaderBackground)
                .lineLimit(1)
        }
        .foregroundColor(.acSecondaryText)
    }
}

// MARK: - Preview

struct DesignRowView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                DesignRowView(designRowViewModel:
                    DesignRowViewModel(design: Design(title: "Jedi", code: "MOPJ15LTDSXC4T", description: "Jedi Tunic")))

                DesignRowView(designRowViewModel:
                    DesignRowViewModel(design: Design(title: "Sam",
                                                      code: "MA667931515180",
                                                      description: "Sokola Island. Might have more StarWars designs"))
                )
            }
        }
    }
}
