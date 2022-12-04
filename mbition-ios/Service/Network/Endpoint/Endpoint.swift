//
//  Endpoint.swift
//  mbition-ios
//
//  Created by Pronin Oleksandr on 04.12.22.
//

import Foundation

struct Endpoint<Kind: EndpointKind, Response: Decodable, Payload: Encodable> {
    let method: Network.HTTPMethod
    let path: String
    let queryItems: [URLQueryItem]?
    let payload: Payload?
    init(path: String, method: Network.HTTPMethod = .get, queryItems: [URLQueryItem]? = nil, payload: Payload? = nil) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.payload = payload
    }
}

protocol EndpointKind {
    associatedtype RequestData
    static func prepare(_ request: inout URLRequest, with data: RequestData)
}

enum EndpointKinds {
    enum Public: EndpointKind {
        static func prepare(_ request: inout URLRequest, with _: Void) {
            // Here we can do things like assign a custom cache
            // policy for loading our publicly available data.
        }
    }
    
    enum Private: EndpointKind {
        static func prepare(_ request: inout URLRequest, with token: AccessToken) {
            request.addValue("Bearer \(token.rawValue)", forHTTPHeaderField: "Authorization")
        }
    }
}

extension Endpoint {
    func makeRequest(with data: Kind.RequestData, host: URLHost = .default) -> URLRequest? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host.rawValue
        components.path = "/" + path
        components.queryItems = queryItems
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        if let payload = payload, let payloadData = try? JSONEncoder().encode(payload) {
            request.httpBody = payloadData
        }
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        Kind.prepare(&request, with: data)
        return request
    }
}

