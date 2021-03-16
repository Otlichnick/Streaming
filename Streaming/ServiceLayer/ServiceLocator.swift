//
//  ServiceLocator.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import Foundation

/// A type representing service locator
protocol ServiceLocatorProtocol {
    
    /// Network API service
    var networkService: NetworkServiceProtocol { get }
    
    /// API URLRequest  builder
    var requestBuilder: RequestBuilderProtocol { get }
    
    /// Stream player manager
    var playerManager: PlayerManagerProtocol { get }
    
    /// Service for stream operations
    var streamService: StreamServiceProtocol { get }
    
    /// Service for building PlaybackURls
    var playbackURLComposer: PlaybackURLComposerProtocol { get }
}

final class ServiceLocator: ServiceLocatorProtocol {
    
    lazy var requestBuilder: RequestBuilderProtocol = RequestBuilder()
    
    lazy var networkService: NetworkServiceProtocol = NetworkService(requestBuilder: requestBuilder)
    
    lazy var playerManager: PlayerManagerProtocol = PlayerManager()
    
    lazy var streamService: StreamServiceProtocol = StreamService(networkService: networkService)
    
    lazy var playbackURLComposer: PlaybackURLComposerProtocol = PlaybackURLComposer()
}
