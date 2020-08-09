//
//  PlayerViewMusicList.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 28/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct PlayerViewMusicList: View {
    @EnvironmentObject private var playerManager: MusicPlayerManager
    @EnvironmentObject private var items: Items
    @Binding var playerMode: PlayerMode
    var namespace: Namespace.ID
    
    
    var body: some View {
        VStack {
            PlayerViewSmall(playerMode: $playerMode, namespace: namespace)
            Spacer()
            List {
                ForEach(items.categories[.music] ?? []) { item in
                    Button(action: {
                        if let song = playerManager.matchSongFrom(item: item) {
                            playerManager.currentSong = song
                            playerManager.isPlaying = true
                            withAnimation(PlayerView.ANIMATION) {
                                playerMode = .playerExpanded
                            }
                        }
                    }) {
                        HStack {
                            ItemImage(path: item.finalImage, size: 50)
                            Text(item.localizedName)
                                .foregroundColor(.acText)
                        }
                    }

                }.listRowBackground(Color.acBackground)
            }
            .animation(.easeInOut)
            .transition(.slide)
        }
        .padding()
        .background(Color.acBackground)
    }
}
