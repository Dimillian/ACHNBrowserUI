//
//  EmptyView.swift
//  ACHNBrowserUI
//
//  Created by Otavio Cordeiro on 27.05.20.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct MessageView: View {

    // MARK: - Properties

    private let string: String

    // MARK: - Life cycle

    init(string: String) {
        self.string = string
    }

    init(collectionName: String) {
        self.string = String.init(format: NSLocalizedString("When you stars some %@, they'll be displayed here.",
                                                            comment: ""), collectionName)
    }

    init(noResultsFor string: String) {
        self.string = String.init(format: NSLocalizedString("No results for %@", comment: ""), string)
    }

    // MARK: - Public

    var body: some View {
        Text(string).foregroundColor(.acSecondaryText)
    }
}

// MARK: - Preview

#if DEBUG
struct CollectionEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageView(string: "Lorem Ipsum")
                .previewLayout(.sizeThatFits)

            MessageView(collectionName: "Pan-dimensional Mice")
                .previewLayout(.sizeThatFits)

            MessageView(collectionName: "Vogons")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }
}
#endif
