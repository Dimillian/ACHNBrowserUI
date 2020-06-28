//
//  PlayerView.swift
//  ACHNBrowserUI
//
//  Created by Thomas Ricouard on 05/06/2020.
//  Copyright © 2020 Thomas Ricouard. All rights reserved.
//

import SwiftUI
import Backend
import UI

struct PlayerView: View {    
    @EnvironmentObject private var playerManager: MusicPlayerManager
    @EnvironmentObject private var items: Items
    @State private var playerMode = PlayerMode.playerSmall
    @Namespace private var namespace
                
    func togglePlayerMode() {
        withAnimation(.spring(response: 0.5,
                              dampingFraction: 0.75,
                              blendDuration: 0)) {
            playerMode.toggleExpanded()
        }
    }
    
    @ViewBuilder
    var body: some View {
        VStack {
            switch playerMode {
            case .playerSmall:
                PlayerViewSmall(playerMode: $playerMode, namespace: _namespace.wrappedValue)
                    .onTapGesture {
                        togglePlayerMode()
                    }
            case .playerExpanded:
                PlayerViewExpanded(playerMode: $playerMode, namespace: _namespace.wrappedValue)
            case .playerMusicList:
                PlayerViewMusicList(playerMode: $playerMode, namespace: _namespace.wrappedValue)
            }
        }
        .frame(height: playerMode.height())
        .background(Color.acTabBarTint)
        .padding(.bottom, 48)
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
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
