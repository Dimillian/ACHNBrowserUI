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

struct TodayMusicPlayerSection: View {
    @EnvironmentObject private var musicPlayerManager: MusicPlayerManager
    @EnvironmentObject private var subscriptionManager: SubscriptionManager
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
            Button(action: {
                self.musicPlayerManager.playmode.toggle()
            }) {
                playModeIcon
                    .imageScale(.large)
                    .foregroundColor(.acText)
            }
            .buttonStyle(PlainButtonStyle())
            Spacer()
        }
    }
    
    private var songsList: some View {
        List {
            if subscriptionManager.subscriptionStatus != .subscribed {
                subscriptionSection
            }
            
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
        .navigationBarTitle(Text("Musics"))
        .listStyle(GroupedListStyle())
        .environment(\.horizontalSizeClass, .regular)
        .sheet(item: $presentedSheet, content: { Sheet(sheetType: $0) })
    }

    private var playModeIcon: Image {
        switch musicPlayerManager.playmode {
        case .random:
            return Image(systemName: "shuffle")
        case .ordered:
            return Image(systemName: "forward.end.alt.fill")
        case .stopEnd:
            return Image(systemName: "stop.fill")
        }
    }
    
    private var subscriptionSection: some View {
        Section(header: SectionHeaderView(text: "AC Helper+", icon: "heart.fill")) {
            VStack(spacing: 8) {
                Button(action: {
                    self.presentedSheet = .subscription(source: .musics, subManager: self.subscriptionManager)
                }) {
                    Text("To help us support the application and get background playing of all the musics, you can try out AC Helper+")
                        .foregroundColor(.acSecondaryText)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 8)
                }
                Button(action: {
                    self.presentedSheet = .subscription(source: .musics, subManager: self.subscriptionManager)
                }) {
                    Text("Learn more...")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }.buttonStyle(PlainRoundedButton())
                    .accentColor(.acHeaderBackground)
                    .padding(.bottom, 8)
            }
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
