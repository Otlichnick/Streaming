//
//  NetworkService+Response.swift
//  Streaming
//
//  Created by Daniil Miroshnichenko on 13.03.2021.
//

import Foundation

extension NetworkService {
    struct CreateStreamResponse: Codable {
        let stream: StreamDTO
        
        enum CodingKeys: String, CodingKey {
            case stream = "data"
        }
    }

    struct StreamsListResponse: Codable {
        let streams: [StreamDTO]
        
        enum CodingKeys: String, CodingKey {
            case streams = "data"
        }
    }
}
