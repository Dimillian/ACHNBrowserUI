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

struct VisualEffectView: UIViewRepresentable {
    
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        let view = UIVisualEffectView()
        view.isUserInteractionEnabled = false
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}

struct PlayerView: View {    
    @EnvironmentObject private var playerManager: MusicPlayerManager
    @EnvironmentObject private var items: Items
    @State private var playerMode = PlayerMode.playerSmall
    @Namespace private var namespace
    
    static let ANIMATION: Animation = .spring(response: 0.5,
                                              dampingFraction: 0.85,
                                              blendDuration: 0)
                
    func togglePlayerMode() {
        withAnimation(Self.ANIMATION) {
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
        .background(VisualEffectView(effect: UIBlurEffect(style: .systemChromeMaterial)))
        .padding(.bottom, 48)
        .gesture(DragGesture()
            .onEnded { value in
                if value.translation.width > 100 {
                    playerManager.previous()
                }
                else if value.translation.width < -100 {
                    playerManager.next()
                } else if value.translation.height > 50 {
                    withAnimation(Self.ANIMATION) {
                        playerMode = .playerSmall
                    }
                } else if value.translation.height > -50 {
                    withAnimation(Self.ANIMATION) {
                        playerMode = .playerExpanded
                    }
                }
            })
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
