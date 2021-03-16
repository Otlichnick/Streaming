//
//  NetworkService.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 13.03.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    
    /// Method makes create live stream request
    /// - https://docs.mux.com/api-reference/video#operation/create-live-stream
    /// - Parameters:
    ///     - result: Completion result with success response or error
    func createLiveStream(
        result: @escaping (Result<NetworkService.CreateStreamResponse, Error>) -> Void
    )
    
    /// Method makes retrieve live stream request
    /// - https://docs.mux.com/api-reference/video#operation/get-live-stream
    /// - Parameters:
    ///     - result: Completion result with success response or error
    func getLiveStream(
        with id: String,
        result: @escaping (Result<NetworkService.CreateStreamResponse, Error>) -> Void
    )
}

final class NetworkService: NetworkServiceProtocol {
    private let requestBuilder: RequestBuilderProtocol
    
    init(requestBuilder: RequestBuilderProtocol) {
        self.requestBuilder = requestBuilder
    }
    
    func createLiveStream(result: @escaping (Result<CreateStreamResponse, Error>) -> Void) {
        guard let request = requestBuilder.buildRequest(for: .createStream) else {
            result(.failure(Errors.requestComposing))
            return
        }
        
        makeRequest(request: request, result: result)
    }
    
    func getLiveStream(with id: String, result: @escaping (Result<CreateStreamResponse, Error>) -> Void) {
        guard let request = requestBuilder.buildRequest(for: .liveStream(id)) else {
            result(.failure(Errors.requestComposing))
            return
        }
        
        makeRequest(request: request, result: result)
    }
}

// MARK: - Private methods
extension NetworkService {
    private func makeRequest<T: Decodable>(
        request: URLRequest,
        result: @escaping (Result<T, Error>) -> Void) {
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let err = error {
                result(.failure(err))
                return
            }
            
            guard let data = data else {
                result(.failure(Errors.parce))
                return
            }
            
            guard let dto = try? JSONDecoder().decode(T.self, from: data) else {
                result(.failure(Errors.retrieveData))
                return
            }

            result(.success(dto))
        }.resume()
    }
}

// MARK: - Errors
extension NetworkService {
    enum Errors: LocalizedError {
        case parce
        case retrieveData
        case requestComposing
        
        var errorDescription: String? {
            switch self {
            case .parce:
                return "Failed to parce JSON"
            case .retrieveData:
                return "Failed to retrieve data"
            case .requestComposing:
                return "Failed to compose request"
            }
        }
    }
}

