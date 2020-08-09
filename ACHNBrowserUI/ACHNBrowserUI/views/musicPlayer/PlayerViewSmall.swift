//
//  PlayerViewSmall.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 28/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI

struct PlayerViewSmall: View {
    @EnvironmentObject private var playerManager: MusicPlayerManager
    @Binding var playerMode: PlayerMode
    var namespace: Namespace.ID
    
    func togglePlayerMode() {
        withAnimation(PlayerView.ANIMATION) {
            playerMode.toggleExpanded()
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            Group {
                if playerManager.currentSongImage != nil {
                    Image(uiImage: playerManager.currentSongImage!)
                        .resizable()
                } else {
                    Rectangle().fill(Color.gray)
                }
            }
            .frame(width: playerMode.coverSize(), height: playerMode.coverSize())
            .cornerRadius(4)
            .shadow(color: .gray, radius: 4, x: 0, y: 0)
            .padding(.leading, 12)
            .matchedGeometryEffect(id: "image", in: namespace)
            
            butttonsView
            
        }
    }
    
    private var butttonsView: some View {
        Group {
            if let name = playerManager.currentSongItem?.name {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.acText)
                    .matchedGeometryEffect(id: name, in: namespace)
            } else {
                ProgressView()
            }
            Spacer()
            
            Button(action: {
                playerManager.previous()
            }) {
                Image(systemName: "backward.fill")
                    .imageScale(.large)
                    .foregroundColor(.acText)
            }
            .padding(.trailing, 8)
            .matchedGeometryEffect(id: "back", in: namespace)
            
            Button(action: {
                playerManager.isPlaying.toggle()
            }) {
                Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                    .imageScale(.large)
                    .foregroundColor(.acText)
            }
            .padding(.trailing, 8)
            .matchedGeometryEffect(id: "play", in: namespace)
            
            Button(action: {
                playerManager.next()
            }) {
                Image(systemName: "forward.fill")
                    .imageScale(.large)
                    .foregroundColor(.acText)
            }
            .padding(.trailing, 8)
            .matchedGeometryEffect(id: "next", in: namespace)
            
            if playerMode == .playerSmall {
                Button(action: {
                    togglePlayerMode()
                }) {
                    Image(systemName: "chevron.up")
                        .imageScale(.large)
                        .rotationEffect(.degrees(playerMode != .playerSmall ? -180 : 0))
                        .foregroundColor(.acText)
                }
                .padding(.trailing, 12)
                .matchedGeometryEffect(id: "chevron", in: namespace)
            } else if playerMode == .playerMusicList {
                Button(action: {
                    withAnimation(.spring(response: 0.5,
                                          dampingFraction: 0.75,
                                          blendDuration: 0)) {
                        playerMode = .playerExpanded
                    }
                }) {
                    Image(systemName: "music.note.list")
                        .imageScale(.large)
                        .foregroundColor(.acText)
                }
                .padding(.trailing, 12)
                .matchedGeometryEffect(id: "list", in: namespace)
            }
        }
    }
}
