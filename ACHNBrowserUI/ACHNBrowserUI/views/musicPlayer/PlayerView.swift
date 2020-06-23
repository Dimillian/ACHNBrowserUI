//
//  PlayerView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 05/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import UI

struct PlayerView: View {
    @EnvironmentObject private var playerManager: MusicPlayerManager
    @State private var isFullScreen = false
    @Namespace private var namespace
    
    private func toggleFullScreen() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.75, blendDuration: 0)) {
            self.isFullScreen.toggle()
        }
    }
    
    private var imageSize: CGFloat {
        isFullScreen ? 200 : 40
    }
    
    private var playerHeight: CGFloat {
        isFullScreen ? 500 : 50
    }
    
    private var playerButtonSize: CGFloat = 38
    
    var body: some View {
        VStack(spacing: 16) {
            if isFullScreen {
                Button(action: {
                    self.toggleFullScreen()
                }) {
                    Image(systemName: "chevron.compact.down")
                        .font(Font.title.weight(.bold))
                        .foregroundColor(.white)
                }
                .padding(.top, 16)
            }
            
            HStack(spacing: 8) {
                if isFullScreen {
                    Spacer()
                }
                
                Group {
                    if playerManager.currentSongImage != nil {
                        Image(uiImage: playerManager.currentSongImage!)
                            .resizable()
                    } else {
                        Rectangle().fill(Color.gray)
                    }
                }
                .frame(width: imageSize, height: imageSize)
                .cornerRadius(4)
                .shadow(color: .gray, radius: 4, x: 0, y: 0)
                .padding(.leading, 12)
                
                if isFullScreen {
                    Spacer()
                }
                
                if !isFullScreen {
                    smallPlayerButtonsView
                }
            }
                        
            if isFullScreen {
                if let name = playerManager.currentSongItem?.name {
                    VStack(spacing: 2) {
                        Text(name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
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
        .frame(height: playerHeight)
        .background(Color.acTabBarTint)
        .padding(.bottom, 48)
        .onTapGesture {
            self.toggleFullScreen()
        }
        .gesture(DragGesture()
            .onEnded { value in
                if value.translation.width > 100 {
                    self.playerManager.previous()
                }
                else if value.translation.width < -100 {
                    self.playerManager.next()
                }
            })
    }
    
    private var smallPlayerButtonsView: some View {
        Group {
            if let name = playerManager.currentSongItem?.name {
                Text(name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .matchedGeometryEffect(id: name, in: namespace)
            } else {
                ProgressView()
            }
            Spacer()
            
            Button(action: {
                self.playerManager.isPlaying.toggle()
            }) {
                Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .padding(.trailing, 8)
            
            Button(action: {
                self.playerManager.next()
            }) {
                Image(systemName: "forward.fill")
                    .imageScale(.large)
                    .foregroundColor(.white)
            }
            .padding(.trailing, 8)
            
            Button(action: {
                self.toggleFullScreen()
            }) {
                Image(systemName: "chevron.up")
                    .imageScale(.large)
                    .rotationEffect(.degrees(isFullScreen ? -180 : 0))
                    .foregroundColor(.white)
            }
            .padding(.trailing, 12)
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
        HStack(spacing: 50) {
            Spacer()
            Button(action: {
                self.playerManager.previous()
            }) {
                Image(systemName: "backward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: playerButtonSize, height: playerButtonSize)
            }
            
            Button(action: {
                self.playerManager.isPlaying.toggle()
            }) {
                Image(systemName: playerManager.isPlaying ? "pause.fill" : "play.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: playerButtonSize, height: playerButtonSize)
            }
            
            Button(action: {
                self.playerManager.next()
            }) {
                Image(systemName: "forward.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.white)
                    .frame(width: playerButtonSize, height: playerButtonSize)
            }
            Spacer()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
