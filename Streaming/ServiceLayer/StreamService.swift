//
//  StreamService.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 16.03.2021.
//

import Foundation

protocol StreamServiceProtocol {
    
    /// Method fetchs live stream
    /// -  if stream is saved on the device fetchs it from UserDefaults
    /// otherwise makes request and saves to UserDefaults
    /// - Parameters:
    ///     - result: Completion result with stream model or error
    func fetchStream(result: @escaping (Result<StreamDTO, Error>) -> Void)
    
    /// Method makes request each 2 seconds
    /// until stream with the given ID is found with the status active
    /// - Parameters:
    ///     - result: Completion result with stream model or error
    func waitForActiveStream(
        with id: String,
        result: @escaping (Result<StreamDTO, Error>) -> Void
    )
}

final class StreamService: StreamServiceProtocol {
    private let networkService: NetworkServiceProtocol
    private var statusRequestLock: Bool = false
    
    @UserDefault(key: .currentStream) private var currentStream: StreamDTO?
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchStream(result: @escaping (Result<StreamDTO, Error>) -> Void) {
        if let storedStream = currentStream {
            result(.success(storedStream))
            return
        }
        
        networkService.createLiveStream { [weak self] r in
            guard let self = self else { return }
            switch r {
            case .success(let response):
                let newStream = response.stream
                self.currentStream = newStream
                result(.success(newStream))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
    
    func waitForActiveStream(
        with id: String,
        result: @escaping (Result<StreamDTO, Error>) -> Void
    ) {
        statusRequestLock = false
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] timer in
            guard let self = self else {
                return
            }
            
            if self.statusRequestLock {
                timer.invalidate()
            } else {
                self.networkService.getLiveStream(with: id) { responseResult in
                    switch responseResult {
                    case .success(let streamResponse):
                        let stream = streamResponse.stream
                        let status = stream.status
                        if status == "active" {
                            self.statusRequestLock = true
                            result(.success(stream))
                            return
                        }
                    case .failure(let error):
                        result(.failure(error))
                    }
                }
            }
        }
    }
}

@propertyWrapper
struct UserDefault<T: Codable> {
    private let userDefaults: UserDefaults
    
    let key: Key
    enum Key: String {
        case currentStream = "current_stream"
    }
    
    init(key: Key, userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.key = key
    }
    
    var wrappedValue: T? {
        get {
            guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
            let object = try? JSONDecoder().decode(T.self, from: data)
            return object
        } set {
            guard let object = newValue else { return }
            let data = try? JSONEncoder().encode(object)
            userDefaults.set(data, forKey: key.rawValue)
        }
    }
}
