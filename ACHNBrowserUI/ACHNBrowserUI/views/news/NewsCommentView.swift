//
//  NewsCommentView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct NewsCommentView: View {
    let news: NewArticle

    var body: some View {
        List {
            Section {
                NewsRow(news: news).listRowBackground(Color.acSecondaryBackground)
            }
            CommentsSection(model: news)
        }
        .animation(.interactiveSpring())
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Comments")
    }
}
