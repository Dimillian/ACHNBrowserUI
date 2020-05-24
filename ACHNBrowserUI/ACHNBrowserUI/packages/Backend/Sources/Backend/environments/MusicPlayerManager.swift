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

public class MusicPlayerManager: ObservableObject {
    public static let shared = MusicPlayerManager()
    
    @Published public var songs: [String: Song] = [:]
    @Published public var currentSongItem: Item?
    @Published public var currentSong: Song? {
        didSet {
            if let song = currentSong {
                currentSongItem = matchItemFrom(song: song)
                let musicURL = ACNHApiService.makeURL(endpoint: .music(id: song.id))
                player?.pause()
                player = AVPlayer(url: musicURL)
            }
        }
    }
    @Published public var isPlaying = false {
        didSet {
            isPlaying ? player?.play() : player?.pause()
        }
    }
    
    private var songsCancellable: AnyCancellable?
    private var player: AVPlayer?
    
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
                                                self?.isPlaying = false
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
}
