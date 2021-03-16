//
//  RequestBuilder.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 13.03.2021.
//

import Foundation

protocol RequestBuilderProtocol {
    
    /// Method builds URLRequest object from given type
    /// - Parameters:
    ///     - kind: Given request type
    func buildRequest(for kind: RequestBuilder.Kind) -> URLRequest?
}

final class RequestBuilder: RequestBuilderProtocol {
    
    /// Type of the request
    enum Kind {
        /// Create new stream (POST)
        case createStream
        /// Get stream description (GET)
        case liveStream(String)
    }
    
    func buildRequest(for kind: Kind) -> URLRequest? {
        switch kind {
        case .createStream:
            return streamCreationRequest()
        case .liveStream(let streamID):
            return getStreamRequest(with: streamID)
        }
    }
}

// MARK: - Private methods
extension RequestBuilder {
    private func streamCreationRequest() -> URLRequest? {
        guard let url = URL(string: BuilderConstants.MUX.baseURL+"/video/v1/live-streams") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        let encodedAuthString = base64AuthString()
        
        request.setValue("Basic \(encodedAuthString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        let body: [String: Any] = [
            "playback_policy": ["public"],
            "new_asset_settings": ["playback_policy": ["public"]
            ]
        ]
        
        guard let jsonBody = try? JSONSerialization.data(
            withJSONObject: body,
            options: .withoutEscapingSlashes
        ) else {
            return nil
        }
        
        request.httpBody = jsonBody
        return request
    }
    
    private func getStreamRequest(with id: String) -> URLRequest? {
        guard let url = URL(string: BuilderConstants.MUX.baseURL+"/video/v1/live-streams/\(id)") else {
            return nil
        }
        
        var request = URLRequest(url: url)
        let encodedAuthString = base64AuthString()
        
        request.setValue("Basic \(encodedAuthString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        return request
    }
    
    private func base64AuthString() -> String {
        let authString = "\(BuilderConstants.MUX.tokenID):\(BuilderConstants.MUX.secret)"
        return Data(authString.utf8).base64EncodedString()
    }
}

// MARK: - Constants
extension RequestBuilder {
    private enum BuilderConstants {
        enum MUX {
            static let baseURL = "https://api.mux.com"
            static let tokenID = "39e39294-944f-47ba-a6ee-083be93d626a"
            static let secret = "wmuUpOvzhGRYC8MhyazFQZdP9glJKy/pyWuI73HoKy5xBylUDJPcmRvHPyMUTraLCfE/iuKwQNR"
        }
    }
}
