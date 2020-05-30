//
//  TodayMusicPlayerSection.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 24/05/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Combine
import Backend
import UI

struct TodayMusicPlayerSection: View {
    @EnvironmentObject private var musicPlayerManager: MusicPlayerManager
    @EnvironmentObject private var items: Items
    
    @State private var presentedSheet: Sheet.SheetType?
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
        }
    }
    
    
    private var playerView: some View {
        VStack(spacing: 8) {
            ProgressView(progress: CGFloat(musicPlayerManager.playProgress),
                         trackColor: .acText,
                         progressColor: .acHeaderBackground,
                         height: 5)
            HStack {
                Text(musicPlayerManager.timeElasped)
                    .foregroundColor(.acText)
                    .font(.callout)
                Spacer()
                Text(musicPlayerManager.duration)
                    .foregroundColor(.acText)
                    .font(.callout)
            }
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
                Button(action: {
                    self.musicPlayerManager.playmode.toggle()
                }) {
                    playModeIcon
                        .imageScale(.large)
                        .foregroundColor(.acText)
                }
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }.padding(.bottom, 16)
        }
    }
    
    private var songsList: some View {
        List {
            Section {
                ForEach(items.categories[.music] ?? []) { item in
                    ItemRowView(displayMode: .largeNoButton, item: item)
                        .onTapGesture {
                            if let song = self.musicPlayerManager.matchSongFrom(item: item) {
                                self.musicPlayerManager.currentSong = song
                                self.musicPlayerManager.isPlaying = true
                                self.isNavigationActive = false
                            }
                    }
                }
            }
        }
        .navigationBarTitle(Text("Tracks"))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .sheet(item: $presentedSheet, content: { Sheet(sheetType: $0) })
    }

    private var playModeIcon: Image {
        switch musicPlayerManager.playmode {
        case .random:
            return Image(systemName: "shuffle")
        case .ordered:
            return Image(systemName: "list.number")
        }
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
