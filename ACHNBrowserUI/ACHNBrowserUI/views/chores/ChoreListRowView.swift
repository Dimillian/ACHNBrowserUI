//
//  ChoreListRowView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 29.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct ChoreListRowView: View {

    // MARK: - Properties

    private let chore: Chore
    private let id = UUID()

    // MARK: - Life cycle

    init(chore: Chore) {
        self.chore = chore
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(chore.title)
                    .style(appStyle: .rowTitle)

                if !chore.description.isEmpty {
                    Text(chore.description)
                        .style(appStyle: .rowDescription)
                }
            }

            Spacer()

            if chore.isFinished {
                Image(systemName: "circle.fill")
                    .foregroundColor(.acHeaderBackground)
            } else {
                Image(systemName: "circle")
                    .foregroundColor(.acHeaderBackground)
            }
        }
    }
}

#if DEBUG
struct ChoreListRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChoreListRowView(chore: Chore(title: "Find Rocks", isFinished: false))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)

            ChoreListRowView(chore: Chore(title: "Sell Hot Items", description: "To pay the last loan", isFinished: true))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
        }
    }
}
#endif
