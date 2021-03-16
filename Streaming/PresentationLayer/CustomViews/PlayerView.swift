//
//  PlayerView.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 14.03.2021.
//

import UIKit
import AVFoundation

class PlayerView: UIView {
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        
        set {
            playerLayer.player = newValue
        }
    }
}

