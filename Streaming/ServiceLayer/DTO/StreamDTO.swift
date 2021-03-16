//
//  StreamDTO.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 13.03.2021.
//

import Foundation

struct StreamDTO: Codable {
    let test: Bool
    let stream_key: String
    let status: String
    let reconnect_window: Int
    let id: String
    let created_at: String
    let playback_ids: [PlaybackId]
    let new_asset_settings: AssetSettings
    
    struct PlaybackId: Codable {
        let policy: String
        let id: String
    }
    
    struct AssetSettings: Codable {
        let playback_policies: [String]
    }
}
