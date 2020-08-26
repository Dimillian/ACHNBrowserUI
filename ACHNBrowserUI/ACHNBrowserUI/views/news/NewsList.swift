//
//  NewsList.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 19/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend

struct NewsList: View {
    @EnvironmentObject private var newsService: NewsArticleService
    
    var body: some View {
        List {
            Section(header: SectionHeaderView(text: "Notifications", icon: "bell.fill")) {
                Toggle(isOn: Binding<Bool>(
                    get: { AppUserDefaults.shared.newsNotifications },
                    set: {
                        AppUserDefaults.shared.newsNotifications = $0
                        if !$0 {
                            self.newsService.disableNotifications()
                        } else {
                            self.newsService.enableNotifications()
                        }
                })) {
                    Text("Get notified when a news is posted")
                        .foregroundColor(.acText)
                }.listRowBackground(Color.acSecondaryBackground)
            }
            
            if self.newsService.articles.isEmpty {
                Section {
                    RowLoadingView().listRowBackground(Color.acSecondaryBackground)
                }
            } else {
                ForEach(newsService.articles) { news in
                    Section {
                        NavigationLink(destination: NewsCommentView(news: news)) {
                            NewsRow(news: news)
                        }.listRowBackground(Color.acSecondaryBackground)
                    }
                }
            }
        }
        .navigationBarTitle("News")
        .listStyle(InsetGroupedListStyle())
        .onAppear(perform: newsService.fetchNews)
    }
}

struct NewsList_Previews: PreviewProvider {
    static var previews: some View {
        NewsList()
    }
}
