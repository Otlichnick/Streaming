//
//  PlayerManager.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 15.03.2021.
//

import UIKit
import AVFoundation

protocol PlayerManagerDelegate: class {
    
    /// Triggered when player is stalled or finished
    func didFinishStreaming()
}

protocol PlayerManagerProtocol {
    
    /// The object that acts as the delegate of the player manager.
    var delegate: PlayerManagerDelegate? { get set }
    
    /// Window with the player view.
    var playerWindow: PlayerWindow { get }
    
    /// Method starts playing stream by given URL
    func play(url: URL)
}

final class PlayerManager: PlayerManagerProtocol {
    private var item: AVPlayerItem?
    
    let playerWindow = PlayerWindow(frame: UIScreen.main.bounds)
    
    weak var delegate: PlayerManagerDelegate?
    
    func play(url: URL) {
        item = AVPlayerItem(url: url)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDidPlayToEndTime(_:)),
            name: .AVPlayerItemDidPlayToEndTime,
            object: item)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleItemPlaybackStalled(_:)),
            name: .AVPlayerItemPlaybackStalled,
            object: item)
        
        guard let item = item else {
            return
        }
        
        playerWindow.playerView.player = AVPlayer(playerItem: item)
        playerWindow.playerView.player?.play()
    }
    
    @objc
    func handleItemPlaybackStalled(_ notification: Notification) {
        playerWindow.playerView.player = AVPlayer()
        delegate?.didFinishStreaming()
    }
    
    @objc
    func handleDidPlayToEndTime(_ notification: Notification) {
        playerWindow.playerView.player = AVPlayer()
        delegate?.didFinishStreaming()
    }
}
