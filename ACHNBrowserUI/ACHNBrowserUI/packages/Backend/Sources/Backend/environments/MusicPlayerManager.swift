//
//  File.swift
//  
//
//  Created by Thomas Ricouard on 24/05/2020.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation
import MediaPlayer
import SDWebImage

public class MusicPlayerManager: ObservableObject {
    public static let shared = MusicPlayerManager()
    
    public enum PlayMode {
        case stopEnd, random, ordered
        
        mutating public func toggle() {
            switch self {
            case .stopEnd:
                self = .random
            case .random:
                self = .ordered
            case .ordered:
                self = .stopEnd
            }
        }
    }
    
    @Published public var songs: [String: Song] = [:]
    @Published public var currentSongItem: Item?
    @Published public var currentSong: Song? {
        didSet {
            if let song = currentSong {
                currentSongItem = matchItemFrom(song: song)
                let musicURL = ACNHApiService.makeURL(endpoint: .music(id: song.id))
                player?.pause()
                player = AVPlayer(url: musicURL)
                
                if SubscriptionManager.shared.subscriptionStatus == .subscribed {
                    setupBackgroundPlay()
                    if !remoteCommandsEnabled {
                        setupRemoteCommands()
                    }
                }
            }
        }
    }
    @Published public var isPlaying = false {
        didSet {
            isPlaying ? player?.play() : player?.pause()
            MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
        }
    }
    
    @Published public var playmode = PlayMode.stopEnd
    
    private var songsCancellable: AnyCancellable?
    private var player: AVPlayer?
    private var remoteCommandsEnabled = false
    
    init() {
        songsCancellable = ACNHApiService
            .fetch(endpoint: .songs)
            .replaceError(with: [:])
            .eraseToAnyPublisher()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] songs in self?.songs = songs })
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem,
                                               queue: .main) { [weak self] _ in
                                                guard let weakself = self else { return }
                                                switch weakself.playmode {
                                                case .stopEnd:
                                                    self?.isPlaying = false
                                                case .random:
                                                    self?.isPlaying = false
                                                    self?.currentSong = self?.songs.randomElement()?.value
                                                    self?.isPlaying = true
                                                case .ordered:
                                                    self?.isPlaying = false
                                                    self?.next()
                                                }
        }
        if SubscriptionManager.shared.subscriptionStatus == .subscribed {
            self.setupRemoteCommands()
        }
    }
    
    public func next() {
        changeSong(newIndex: 1)
    }
    
    public func previous() {
        changeSong(newIndex: -1)
    }
    
    private func changeSong(newIndex: Int) {
        guard let current = currentSongItem,
            var index = Items.shared.categories[.music]?.firstIndex(of: current) else {
                return
        }
        index += newIndex
        if index > 0 && index < Items.shared.categories[.music]?.count ?? 0 {
            if let newSong = Items.shared.categories[.music]?[index],
                let song = matchSongFrom(item: newSong) {
                currentSong = song
                isPlaying = true
            }
        }
    }
    
    public func matchSongFrom(item: Item) -> Song? {
        songs[item.filename ?? ""]
    }
    
    public func matchItemFrom(song: Song) -> Item? {
        Items.shared.categories[.music]?.first(where: { $0.filename == song.fileName })
    }
    
    private func setupRemoteCommands() {
        remoteCommandsEnabled = true
        
        MPRemoteCommandCenter.shared().playCommand.addTarget { [weak self] event in
            if self?.isPlaying == false {
                self?.isPlaying = true
                return .success
            }
            return .commandFailed
        }
        
        MPRemoteCommandCenter.shared().pauseCommand.addTarget { [weak self] event in
            if self?.isPlaying == true {
                self?.isPlaying = false
                return .success
            }
            return .commandFailed
        }
        
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget { [weak self] event in
            self?.next()
            return .success
        }
        
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget { [weak self] event in
            self?.previous()
            return .success
        }
    }
    
    private func setupBackgroundPlay() {
        if let item = currentSongItem,
            let filename = item.finalImage {
            SDWebImageDownloader.shared.downloadImage(with: ImageService.computeUrl(key: filename)) { (image, _, _, _) in
                if let image = image {
                    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
                    try? AVAudioSession.sharedInstance().setActive(true, options: [])
                    
                    UIApplication.shared.beginReceivingRemoteControlEvents()
                    
                    let info: [String: Any] =
                        [MPMediaItemPropertyArtist: "K.K Slider",
                         MPMediaItemPropertyAlbumTitle: "K.K Slider",
                         MPMediaItemPropertyTitle: self.currentSongItem?.name ?? "",
                         MPMediaItemPropertyArtwork: MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100),
                                                                        requestHandler: { (size: CGSize) -> UIImage in
                            return image
                         })]
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = info
                }
            }
        }
    }
}
