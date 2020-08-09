//
//  PlayerViewExpanded.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 28/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import UI

struct PlayerViewExpanded: View {
    @EnvironmentObject private var playerManager: MusicPlayerManager
    @Binding var playerMode: PlayerMode
    var namespace: Namespace.ID
    
    private let playerButtonSize: CGFloat = 38
    
    func togglePlayerMode() {
        withAnimation(PlayerView.ANIMATION) {
            playerMode.toggleExpanded()
        }
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                togglePlayerMode()
            }) {
                Image(systemName: "chevron.compact.down")
                    .font(Font.title.weight(.bold))
                    .foregroundColor(.acText)
                    .matchedGeometryEffect(id: "chevron", in: namespace)
            }
            .padding(.top, 16)
            
            
            HStack {
                Spacer()
                
                Group {
                    if playerManager.currentSongImage != nil {
                        Image(uiImage: playerManager.currentSongImage!)
                            .resizable()
                    } else {
                        Rectangle()
                            .fill(Color.gray)
                    }
                }
                .frame(width: playerMode.coverSize(), height: playerMode.coverSize())
                .cornerRadius(4)
                .shadow(color: .gray, radius: 4, x: 0, y: 0)
                .padding(.leading, 12)
                .matchedGeometryEffect(id: "image", in: namespace)
                
                Spacer()
            }
            
            if let name = playerManager.currentSongItem?.localizedName {
                VStack(spacing: 2) {
                    Text(name)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.acText)
                        .matchedGeometryEffect(id: name, in: namespace)
                    Text("K.K Slider")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.acBlueText)
                }
            } else {
                ProgressView()
            }
            playerTimeView
            playerButtonsView
            Spacer()
        }
    }
    
    private var playerTimeView: some View {
        VStack {
            ProgressBar(progress: CGFloat(playerManager.playProgress),
                        trackColor: .acText,
                        progressColor: .acHeaderBackground,
                        height: 5)
            HStack {
                Text(playerManager.timeElasped)
                    .foregroundColor(.acBlueText)
                    .font(.body)
                Spacer()
                Text(playerManager.duration)
                    .foregroundColor(.acBlueText)
                    .font(.body)
            }
        }
        .padding(.leading, 32)
        .padding(.trailing, 32)
    }
    
    private var playerButtonsView: some View {
        VStack {
            HStack(spacing: 50) {
                Spacer()
                Button(action: {
                    playerManager.previous()
                }) {
                    Image(systemName: "backward.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: playerButtonSize, height: playerButtonSize)
                        .foregroundColor(.acText)
                }
                .matchedGeometryEffect(id: "back", in: namespace)
                
                Button(action: {
                    playerManager.isPlaying.toggle()
                }) {
                    Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: playerButtonSize, height: playerButtonSize)
                        .foregroundColor(.acText)
                }
                .matchedGeometryEffect(id: "play", in: namespace)
                
                Button(action: {
                    playerManager.next()
                }) {
                    Image(systemName: "forward.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: playerButtonSize, height: playerButtonSize)
                        .foregroundColor(.acText)
                }
                .matchedGeometryEffect(id: "next", in: namespace)
                
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                withAnimation(.spring(response: 0.5,
                                      dampingFraction: 0.75,
                                      blendDuration: 0)) {
                    playerMode = .playerMusicList
                }
            }) {
                Image(systemName: "music.note.list")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: playerButtonSize, height: playerButtonSize)
                    .foregroundColor(.acText)
            }
            .matchedGeometryEffect(id: "list", in: namespace)
            
            Spacer()
        }
    }
}

