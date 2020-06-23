//
//  TodayNewsSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct TodayNewsSection: View {
    @EnvironmentObject private var newsService: NewsArticleService
    
    var body: some View {
        NavigationLink(destination: NewsList()) {
            if newsService.articles.isEmpty == true {
                RowLoadingView()
            } else {
                NewsRow(news: newsService.articles.first!)
            }
        }
    }
}

struct TodayNewsSection_Previews: PreviewProvider {
    static var previews: some View {
        TodayNewsSection()
    }
}
