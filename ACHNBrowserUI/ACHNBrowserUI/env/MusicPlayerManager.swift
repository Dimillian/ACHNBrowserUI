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
import Backend

public class MusicPlayerManager: ObservableObject {
    public static let shared = MusicPlayerManager()
    
    public enum PlayMode {
        case random, ordered
        
        mutating public func toggle() {
            switch self {
            case .random:
                self = .ordered
            case .ordered:
                self = .random
            }
        }
    }
    
    @Published public var songs: [String: Song] = [:] {
        didSet {
            if currentSong == nil,
                let random = songs.values.map({ $0 }).randomElement() {
                currentSong = random
            }
        }
    }
    @Published public var currentSongItem: Item?
    @Published public var currentSong: Song? {
        didSet {
            if let song = currentSong {
                currentSongItem = matchItemFrom(song: song)
                let musicURL = ACNHApiService.makeURL(endpoint: .music(id: song.id))
                player?.pause()
                player = AVPlayer(url: musicURL)
                
                setupBackgroundPlay()
            }
        }
    }
    @Published public var isPlaying = false {
        didSet {
            isPlaying ? player?.play() : player?.pause()
            if isPlaying {
                if timeTimer != nil {
                    timeTimer?.invalidate()
                    timeTimer = nil
                }
                timeTimer = Timer.scheduledTimer(withTimeInterval: 0.5,
                                                 repeats: true,
                                                 block:
                { [weak self] timer in
                    if let duration = self?.player?.currentItem?.duration.seconds,
                        let playTime = self?.player?.currentItem?.currentTime().seconds,
                        !duration.isNaN, !playTime.isNaN {
                        let durationSecs = Int(duration)
                        let durationSeconds = Int(durationSecs % 3600 ) % 60
                        let durationMinutes = Int(durationSecs % 3600) / 60
                        let durationString = "\(durationMinutes):\(String(format: "%02d", durationSeconds))"
                        self?.duration = durationString
                        
                        let playTimeSecs = Int(playTime)
                        let playTimeSeconds = Int(playTimeSecs % 3600) % 60
                        let playTimeMinutes = Int(playTimeSecs % 3600) / 60
                        let timeElapsedString = "\(playTimeMinutes):\(String(format: "%02d", playTimeSeconds))"
                        self?.timeElasped = timeElapsedString
                        
                        self?.playProgress = Float(playTime) / Float(duration)
                        
                        var infos = MPNowPlayingInfoCenter.default().nowPlayingInfo
                        infos?[MPMediaItemPropertyPlaybackDuration] = duration
                        infos?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playTime
                        MPNowPlayingInfoCenter.default().nowPlayingInfo = infos
                    }
                })
            } else {
                timeTimer?.invalidate()
                timeTimer = nil
            }
            MPNowPlayingInfoCenter.default().playbackState = isPlaying ? .playing : .paused
        }
    }
    
    @Published public var playmode = PlayMode.random
    
    private var timeTimer: Timer?
    
    @Published public var duration = "0:00"
    @Published public var timeElasped = "0:00"
    @Published public var playProgress: Float = 0
    
    private var songsCancellable: AnyCancellable?
    private var itemsCancellable: AnyCancellable?
    private var player: AVPlayer?
    
    init() {
        songsCancellable = ACNHApiService
            .fetch(endpoint: .songs)
            .replaceError(with: [:])
            .eraseToAnyPublisher()
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] songs in
                self?.songs = songs
            })

        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem,
                                               queue: .main) { [weak self] _ in
                                                guard let weakself = self else { return }
                                                switch weakself.playmode {
                                                case .random:
                                                    self?.isPlaying = false
                                                    self?.currentSong = self?.songs.randomElement()?.value
                                                    self?.isPlaying = true
                                                case .ordered:
                                                    self?.isPlaying = false
                                                    self?.next()
                                                }
        }
        self.setupRemoteCommands()
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
            let song = currentSong {
            SDWebImageDownloader.shared.downloadImage(with:
            ACNHApiService.Endpoint.songsImage(id: song.id).url()) { (image, _, _, _) in
                if let image = image {
                    try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, policy: .longFormAudio, options: [])
                    try? AVAudioSession.sharedInstance().setActive(true, options: [])
                    
                    UIApplication.shared.beginReceivingRemoteControlEvents()
                    
                    let info: [String: Any] =
                        [MPMediaItemPropertyArtist: "K.K Slider",
                         MPMediaItemPropertyAlbumTitle: "K.K Slider",
                         MPMediaItemPropertyTitle: item.name,
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
