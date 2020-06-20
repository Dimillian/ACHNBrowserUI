//
//  NewsRow.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct NewsRow: View {
    let news: NewArticle
    
    @State private var voted = false
    
    private var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(news.title)
                .foregroundColor(.acText)
                .font(.headline)
                .fontWeight(.bold)
            Text(news.content)
                .foregroundColor(.acText)
                .font(.body)
                .foregroundColor(.acText)
            HStack {
                Text(formatter.string(from: news.creationDate))
                    .font(.footnote)
                    .foregroundColor(.acSecondaryText)
                Spacer()
                upvoteButton
            }
        }
    }
    
    private var upvoteButton: some View {
        Button(action: {
            if !self.voted {
                self.voted = true
                NewsArticleService.shared.upvoteArticle(article: self.news)
                FeedbackGenerator.shared.triggerSelection()
            }
        }) {
            ButtonImageCounterOverlay(symbol: voted ? "hand.thumbsup.fill" : "hand.thumbsup",
                                      foregroundColor: .green,
                                      counter: news.upvotes)
        }
        .buttonStyle(BorderlessButtonStyle())
        .padding(.trailing, 4)
    }
}
