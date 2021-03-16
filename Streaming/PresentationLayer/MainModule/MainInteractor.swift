//
//  MainInteractor.swift
//  Aster
//
//  Created by Daniil Miroshnichenko on 14.03.21.
//

import Foundation

final class MainInteractor: MainInteractorProtocol {
    private let streamService: StreamServiceProtocol
    private let playbackURLComposer: PlaybackURLComposerProtocol
    
    var currentStream: StreamDTO?
    
    init(streamService: StreamServiceProtocol, playbackURLComposer: PlaybackURLComposerProtocol) {
        self.streamService = streamService
        self.playbackURLComposer = playbackURLComposer
    }
    
    // MARK: MainInteractorProtocol
    func fetchPlaybackURL(result: @escaping (Result<URL, Error>) -> Void) {
        streamService.fetchStream { [weak self] streamResult in
            guard let self = self else {
                return
            }
            
            switch streamResult {
            case .success(let stream):
                self.currentStream = stream
                self.streamService.waitForActiveStream(with: stream.id) { r in
                    switch r {
                    case .success(let activeStream):
                        if let playbackURL = self.playbackURLComposer.composeURL(for: .mux, from: activeStream) {
                            result(.success(playbackURL))
                            return
                        }
                        
                        result(.failure(MainInteractorError.urlComposing))
                    case .failure(let error):
                        result(.failure(error))
                    }
                }
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}

// MARK: Errors
extension MainInteractor {
    enum MainInteractorError: LocalizedError {
        case urlComposing
        
        var errorDescription: String? {
            switch self {
            case .urlComposing:
                return "Playback URL composing error"
            }
        }
    }

}
