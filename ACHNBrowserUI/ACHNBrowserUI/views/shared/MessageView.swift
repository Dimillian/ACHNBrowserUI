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

    private let string: LocalizedStringKey

    // MARK: - Life cycle

    init(_ string: LocalizedStringKey) {
        self.string = string
    }

    init(collectionName: String) {
        self.string = "When you stars some \(NSLocalizedString(collectionName, comment: "")), they'll be displayed here."
    }

    init(noResultsFor string: String) {
        self.string = "No results for \(string)"
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
            MessageView("Lorem Ipsum")
                .previewLayout(.sizeThatFits)

            MessageView(collectionName: "Pan-dimensional Mice")
                .previewLayout(.sizeThatFits)

            MessageView(collectionName: "Vogons")
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            
            MessageView(noResultsFor: "Lorem Ipsum")
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
        }
    }
}
#endif
