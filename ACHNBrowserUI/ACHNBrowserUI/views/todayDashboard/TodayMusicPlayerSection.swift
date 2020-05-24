//
//  TodayMusicPlayerSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 24/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Combine
import Backend

struct TodayMusicPlayerSection: View {
    @EnvironmentObject private var musicPlayerManager: MusicPlayerManager
    @EnvironmentObject private var items: Items
    
    @State private var isNavigationActive = false
    
    var body: some View {
        Section(header: SectionHeaderView(text: "Music player",
                                          icon: "music.note"))
        {
            if musicPlayerManager.currentSongItem != nil {
                NavigationLink(destination: songsList, isActive: $isNavigationActive) {
                    ItemRowView(displayMode: .largeNoButton, item: musicPlayerManager.currentSongItem!)
                }
                playerView
            } else {
                RowLoadingView(isLoading: .constant(true))
            }
        }.onAppear {
            if self.musicPlayerManager.currentSong == nil,
                let random = self.items.categories[.music]?.randomElement(),
                let song = self.musicPlayerManager.matchSongFrom(item: random) {
                self.musicPlayerManager.currentSong = song
            }
        }
    }
    
    
    private var playerView: some View {
        HStack(alignment: .center, spacing: 32) {
            Spacer()
            Button(action: {
                self.musicPlayerManager.previous()
            }) {
                Image(systemName: "backward.fill")
                    .imageScale(.large)
                    .foregroundColor(.acText)
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                self.musicPlayerManager.isPlaying.toggle()
            }) {
                Image(systemName: musicPlayerManager.isPlaying ? "pause.fill" : "play.fill")
                    .imageScale(.large)
                    .foregroundColor(.acText)
            }
            .buttonStyle(PlainButtonStyle())
            Button(action: {
                self.musicPlayerManager.next()
            }) {
                Image(systemName: "forward.fill")
                    .imageScale(.large)
                    .foregroundColor(.acText)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
    
    private var songsList: some View {
        List(items.categories[.music] ?? []) { item in
            ItemRowView(displayMode: .largeNoButton, item: item)
                .onTapGesture {
                    if let song = self.musicPlayerManager.matchSongFrom(item: item) {
                        self.musicPlayerManager.currentSong = song
                        self.musicPlayerManager.isPlaying = true
                        self.isNavigationActive = false
                    }
            }
        }.navigationBarTitle(Text("Musics"))
    }
}

struct TodayMusicPlayer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            List {
                TodayMusicPlayerSection()
            }
            .listStyle(GroupedListStyle())
            .environment(\.horizontalSizeClass, .regular)
            .environmentObject(MusicPlayerManager.shared)
            .environmentObject(Items.shared)
        }
    }
}
