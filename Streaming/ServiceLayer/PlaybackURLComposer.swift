//
//  PlaybackURLComposer.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 16.03.2021.
//

import Foundation

protocol PlaybackURLComposerProtocol {
    
    /// Method builds playbackURL from stream
    /// - Parameters:
    ///     - platform: Streaming platform
    ///     - Stream: Stream model
    func composeURL(for platform: PlaybackURLComposer.StreamPlatform, from stream: StreamDTO) -> URL?
}

final class PlaybackURLComposer: PlaybackURLComposerProtocol {
    
    enum StreamPlatform {
        ///https://docs.mux.com/guides/video/start-live-streaming
        case mux
    }
    
    func composeURL(for platform: StreamPlatform, from stream: StreamDTO) -> URL? {
        guard let playbackID = stream.playback_ids.first else {
            return nil
        }
        
        switch platform {
        case .mux:
            let urlString = ServiceConstants.muxBasePlaybackURL + "\(playbackID.id).m3u8"
            return URL(string: urlString)
        }
    }
}

// MARK: - Constants
extension PlaybackURLComposer {
    private enum ServiceConstants {
        static let muxBasePlaybackURL = "https://stream.mux.com/"
    }
}
